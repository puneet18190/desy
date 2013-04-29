require 'media'
require 'media/video'
require 'media/uploader'
require 'media/similar_durations'
require 'media/video/editing/cmd/extract_frame'
require 'media/video/editing/conversion'
require 'media/video/editing/conversion/job'
require 'media/image/editing/resize_to_fill'
require 'env_relative_path'

module Media
  module Video
    class Uploader < Uploader

      require 'media/video/uploader/validation'

      include Validation
      include EnvRelativePath

      # Path to videos folder relative to Rails public folder (for web URLs)
      PUBLIC_RELATIVE_FOLDER        = env_relative_path File.join(PUBLIC_RELATIVE_MEDIA_ELEMENTS_FOLDER, 'videos')
      # Absolute path to videos folder
      FOLDER                        = File.join RAILS_PUBLIC_FOLDER, PUBLIC_RELATIVE_FOLDER
      # Allowed uploaded video extensions
      EXTENSION_WHITE_LIST          = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)
      # Allowed uploaded video extensions with dots
      EXTENSION_WHITE_LIST_WITH_DOT = EXTENSION_WHITE_LIST.map{ |ext| ".#{ext}" }
      # Minimum allowed uploaded video duration
      MIN_DURATION                  = 1
      # Maximum difference between two generated formats of the same video
      DURATION_THRESHOLD            = CONFIG.duration_threshold
      # Video ouput formats
      FORMATS                       = FORMATS
      # Allowed keys when initializing a new Media::Video::Uploader instance with an hash as value
      ALLOWED_KEYS                  = [:filename] + FORMATS
      # Output versiosn formats (thumb, cover...)
      VERSION_FORMATS               = VERSION_FORMATS
      # Ruby class responsible of the conversion process
      CONVERSION_CLASS              = Editing::Conversion

      private

      # Generate the additional versions
      def extract_versions(infos) # :doc:
        cover_path = File.join output_folder, COVER_FORMAT % processed_original_filename_without_extension
        extract_cover @converted_files[:mp4], cover_path, infos[:mp4].duration

        thumb_path = File.join output_folder, THUMB_FORMAT % processed_original_filename_without_extension
        extract_thumb cover_path, thumb_path, *THUMB_SIZES
      end

      # Generate the additional cover versions
      def extract_cover(input, output, duration) # :doc:
        seek = duration / 2
        Editing::Cmd::ExtractFrame.new(input, output, seek).run!
        raise StandardError, 'unable to create cover' unless File.exists? output
      end

      # Generate the additional thumb versions
      def extract_thumb(input, output, width, height) # :doc:
        Image::Editing::ResizeToFill.new(input, output, width, height).run
      end
    end
  end
end
