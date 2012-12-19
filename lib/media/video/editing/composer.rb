require 'media'
require 'media/video'
require 'media/video/editing'

module Media
  module Video
    module Editing
      class Composer

        #  {
        #    :initial_video => OBJECT OF TYPE VIDEO or NIL,
        #    :audio_track => OBJECT OF TYPE AUDIO or NIL,
        #    :components => [
        #      {
        #        :type => Video::VIDEO_COMPONENT,
        #        :video => OBJECT OF TYPE VIDEO,
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
        #        :image => OBJECT OF TYPE IMAGE,
        #        :duration => 2
        #      }
        #    ]
        #  }
        def initialize(params)
          @params = params
        end

        def run
          @params[:components].each do |component|
            type, video, from, to = components.values_at(:type, :video, :from, :to)
          end
        end

        def video_id
          @params[:initial_video].try(:id)
        end

        def audio_id
          @params[:audio_track].try(:id)
        end
      end
    end
  end
end