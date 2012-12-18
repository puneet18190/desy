require 'media'
require 'media/video'
require 'media/video/editing'

module Media
  module Video
    module Editing
      class Composer

        #  {
        #    :initial_video => {
        #      :id => VIDEO ID or NIL,
        #    },
        #    :audio_track_id => AUDIO ID or NIL,
        #    :components => [
        #      {
        #        :type => Video::VIDEO_COMPONENT,
        #        :video_id => VIDEO ID,
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
        #        :image_id => IMAGE ID,
        #        :duration => 2
        #      }
        #    ]
        #  }
        def initialize(params)
          @params = params
        end

        def run
          @params[:components].map do |component|
            Thread.new do
              case component[:type]
              when ::Video::VIDEO_COMPONENT
                compose_video *component.values_at(:video_id, :from, :to)
              when ::Video::AUDIO_COMPONENT
              when ::Video::TEXT_COMPONENT
              end
            end.tap{ |t| t.abort_on_exception = true }
          end.each(&:join)
        end

        private
        def compose_video(video_id, from, to)
          video = Video.find video_id
          

        end

        def final_video
          @video ||= (
            id = @params[:initial_video][:id]
            Video.find(id) if id
          )
        end

        def final_audio
          @audio ||= (
            id = @params[:audio_track_id]
            Audio.find(id) if id
          )
        end
      end
    end
  end
end