require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/in_tmp_dir'
require 'sensitive_thread'

module Media
  module Video
    module Editing
      class Composer

        include InTmpDir

        #  {
        #    :initial_video => {
        #      :id => VIDEO ID or NIL,
        #      :title => 'title',
        #      :...
        #    },
        #    :audio_track_id => AUDIO ID or NIL,
        #    :components => [
        #      {
        #        :type => Video::VIDEO_COMPONENT,
        #        :video => VIDEO ID,
        #        :from => 12,
        #        :to => 24
        #      },
        #      {
        #        :type => Video::TEXT_COMPONENT,
        #        :content => 'Titolo titolo titolo',
        #        :duration => 14,
        #        :background_color => 'red',
        #        :text_color => 'white'
        #      },
        #      {
        #        :type => Video::IMAGE_COMPONENT,
        #        :image => IMAGE ID,
        #        :duration => 2
        #      }
        #    ]
        #  }
        def initialize(params)
          @params = params
        end

        def run
          in_tmp_dir do

            concats = {}

            @params[:components].each_with_index.map do |component, i|
              raise [component, i].inspect
              @i = i
              SensitiveThread.new do
                puts "thread i: #{@i}"
                concats.store i,
                  case component[:type]
                  when ::Video::VIDEO_COMPONENT
                    compose_video *component.values_at(:video, :from, :to)
                  when ::Video::IMAGE_COMPONENT
                    compose_image *component.values_at(:image, :duration)
                  when ::Video::TEXT_COMPONENT
                    compose_text *component.values_at(:content, :duration, :text_color, :background_color)
                  else
                    # TODO messaggio migliore
                    raise "unknown component type: #{component[:type].inspect}"
                  end
              end
            end.each(&:join)

            concats_sorted = concats.sort
            concats_sorted[0, concats_sorted.size-1].map do |i, concat|
              next_concat = concats_sorted[i+1]
              SensitiveThread.new do
                concats.store (i+1)/2.0, Transition.new(concat, next_concat).run
              end
            end.each(&:join)

          end
        end


        private
        def compose_text(text, duration, color, background_color)
          text_file = tmp_path "text_#{@i}.txt"
          File.open(text_file, 'w') { |f| f.write text }
          TextToVideo.new(text_file, output_without_extension, duration, color: color, background_color: background_color).run
        end

        def compose_image(image_id, duration)
          image = Image.find image_id
          ImageToVideo.new(image.media.path, output_without_extension, duration).run
        end

        def compose_video(video_id, from, to)
          video = ::Video.find video_id
          if video.converted.nil?
            # TODO messaggio migliore
            raise 'could not edit a video while converting'
          end

          inputs = Hash[ FORMATS.map{ |f| [f, video.media.absolute_path(f)] } ]

          if from == 0 && to == video.min_duration
            {}.tap do |outputs|
              inputs.map do |format, input|
                outputs[f] = output = "#{output_without_extension}.#{format}"
                SensitiveThread.new{ video_copy input, output }
              end.each(&:join)
            end
          else
            start, duration = from, to-from
            Crop.new(inputs, output_without_extension, start, duration).run
          end
        end

        def video_copy(input, output)
          # se uso l'audio di sottofondo scarto gli stream audio, così poi non perdo tempo a convertirli
          if final_audio
            Cmd::VideoStreamToFile.new(input, output).run!
          else
            FileUtils.cp(input, output)
          end
        end

        def output_without_extension
          tmp_path @i.to_s
        end

        def final_video
          @video ||= (
            id = @params[:initial_video][:id]
            ::Video.find(id) if id
          )
        end

        def final_audio
          @audio ||= (
            id = @params[:audio_track]
            ::Audio.find(id) if id
          )
        end
      end
    end
  end
end