require 'media'
require 'media/video'

module Media
  module Video
    class Placeholder
      PUBLIC_RELATIVE_FOLDER     = '/media_elements/videos/placeholder'
      FILENAME_WITHOUT_EXTENSION = 'placeholder'
      FILENAME                   = Hash[ FORMATS.map{ |f| [f, "#{FILENAME_WITHOUT_EXTENSION}.#{f}"] } ]
      DURATION                   = 5

      class << self
        def url(format = nil)
          case format
          when ->(f) { f.blank? }
            File.join PUBLIC_RELATIVE_FOLDER, FILENAME_WITHOUT_EXTENSION
          when *FORMATS
            File.join PUBLIC_RELATIVE_FOLDER, FILENAME[format]
          when :cover, :thumb
            File.join PUBLIC_RELATIVE_FOLDER, VERSION_FORMATS[format] % FILENAME_WITHOUT_EXTENSION
          end
        end

        def mp4_duration
          DURATION
        end

        def webm_duration
          DURATION
        end

      end
    end
  end
end
