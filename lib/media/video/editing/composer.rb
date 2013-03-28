require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/in_tmp_dir'
require 'media/error'
require 'media/video/editing/parameters'
require 'media/thread'
require 'media/video/editing/crop'
require 'media/video/editing/text_to_video'
require 'media/video/editing/image_to_video'
require 'media/video/editing/concat'
require 'media/audio'

module Media
  module Video
    module Editing
      class Composer

        include InTmpDir

        #  {
        #    :initial_video => {
        #      :id => VIDEO ID
        #    },
        #    :audio_track_id => AUDIO ID or NIL,
        #    :components => [
        #      {
        #        :type => VIDEO_COMPONENT,
        #        :video => VIDEO ID,
        #        :from => 12,
        #        :to => 24
        #      },
        #      {
        #        :type => TEXT_COMPONENT,
        #        :content => 'Titolo titolo titolo',
        #        :duration => 14,
        #        :background_color => 'red',
        #        :text_color => 'white'
        #      },
        #      {
        #        :type => IMAGE_COMPONENT,
        #        :image => IMAGE ID,
        #        :duration => 2
        #      }
        #    ]
        #  }
        def initialize(params)
          @params = params
        end

        def run
          @old_media = video.media.try(:dup)
          compose
          @old_media.paths.values.each{ |p| FileUtils.rm_f p } if @old_media
        rescue StandardError => e
          if @old_media
            video.media     = @old_media.to_hash
            video.converted = true
            if old_fields = video.try(:metadata).try(:old_fields)
              video.title       = old_fields['title'] if old_fields['title'].present?
              video.description = old_fields['description'] if old_fields['description'].present?
              video.tags        = old_fields['tags'] if old_fields['tags'].present?
            end
            video.save!
            video.enable_lessons_containing_me
            Notification.send_to video.user_id, I18n.t('notifications.video.compose.update.failed', item: video.title, link: ::Video::CACHE_RESTORE_PATH)
          else
            video.destroyable_even_if_not_converted = true
            video.destroy
            Notification.send_to video.user_id, I18n.t('notifications.video.compose.create.failed', item: video.title, link: ::Video::CACHE_RESTORE_PATH)
          end

          raise e
        end

        def compose
          in_tmp_dir do
            concats = {}

            Thread.join *@params[:components].each_with_index.map { |component, i|
              proc {
                concats.store i,
                  case component[:type]
                  when Parameters::VIDEO_COMPONENT
                    compose_video *component.values_at(:video, :from, :to), i
                  when Parameters::IMAGE_COMPONENT
                    compose_image *component.values_at(:image, :duration), i
                  when Parameters::TEXT_COMPONENT
                    compose_text *component.values_at(:content, :duration, :text_color, :background_color), i
                  else
                    raise Error.new("wrong component type", type: component[:type])
                  end
              }
            }

            concats_sorted = concats.sort
            Thread.join *concats_sorted[0, concats_sorted.size-1].map { |i, concat|
              next_i = i+1
              next_concat = concats_sorted[next_i][1]
              proc {
                transition_i = (i+next_i)/2.0
                concats.store transition_i, Transition.new(concat, next_concat, tmp_path(transition_i.to_s)).run
              }
            }

            concat = tmp_path 'concat'
            outputs = Concat.new(concats.sort.map{ |_,c| c }, concat).run

            if audio
              audios = Hash[ Media::Audio::FORMATS.map{ |f| [f, audio.media.path(f)] } ]
              outputs = ReplaceAudio.new(outputs, audios, tmp_path('replace_audio')).run
            end

            video.media               = outputs.merge(filename: video.title)
            video.composing           = nil
            video.metadata.old_fields = nil

            ActiveRecord::Base.transaction do
              video.save!
              video.enable_lessons_containing_me
              Notification.send_to video.user_id, I18n.t("notifications.video.compose.#{notification_translation_key}.ok", item: video.title)
              video.user.video_editor_cache!
            end
          end
        end

        private
        def compose_text(text, duration, color, background_color, i)
          text_file = Pathname.new tmp_path "text_#{i}.txt"
          text_file.open('w') { |f| f.write text }
          TextToVideo.new(text_file, output_without_extension(i), duration, color: color, background_color: background_color).run
        end

        def compose_image(image_id, duration, i)
          image = ::Image.find image_id
          ImageToVideo.new(image.media.path, output_without_extension(i), duration).run
        end

        def compose_video(video_id, from, to, i)
          video = ::Video.find video_id
          inputs = Hash[ FORMATS.map{ |f| [f, video.media.path(f)] } ]

          if from == 0 && to == video.min_duration
            {}.tap do |outputs|
              Thread.join *inputs.map { |format, input| proc { video_copy input, (outputs[format] = "#{output_without_extension(i)}.#{format}") } }
            end
          else
            start, duration = from, to-from
            Crop.new(inputs, output_without_extension(i), start, duration).run
          end
        end

        def notification_translation_key
          @old_media ? 'update' : 'create'
        end

        def video_copy(input, output)
          if audio
            # scarto gli stream audio, così poi non perdo tempo a processare le tracce audio inutilmente
            Cmd::VideoStreamToFile.new(input, output).run!
          else
            FileUtils.cp(input, output)
          end
        end

        def output_without_extension(i)
          tmp_path i.to_s
        end

        def video
          @video ||= ::Video.find @params[:initial_video][:id]
        end

        def audio
          @audio ||= (
            id = @params[:audio_track]
            ::Audio.find(id) if id
          )
        end
      end
    end
  end
end
