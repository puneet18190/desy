require 'media'
require 'media/video'

module Media
  module Video
    class Placeholder
      FOLDER                      = 'media_elements/videos/placeholder'
      ABSOLUTE_FOLDER             = RAILS_PUBLIC_FOLDER.join FOLDER
      PUBLIC_RELATIVE_FOLDER_ROOT = File.join '/', FOLDER
      FILENAME_WITHOUT_EXTENSION  = 'placeholder'
      FILENAME                    = Hash[ FORMATS.map{ |f| [f, "#{FILENAME_WITHOUT_EXTENSION}.#{f}"] } ]
      DURATION                    = 5

      class << self
        def url(format = nil)
          case format
          when ->(f) { f.blank? }
            File.join PUBLIC_RELATIVE_FOLDER_ROOT, FILENAME_WITHOUT_EXTENSION
          when *FORMATS
            File.join PUBLIC_RELATIVE_FOLDER_ROOT, FILENAME[format]
          when :cover, :thumb
            File.join PUBLIC_RELATIVE_FOLDER_ROOT, VERSION_FORMATS[format] % FILENAME_WITHOUT_EXTENSION
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
