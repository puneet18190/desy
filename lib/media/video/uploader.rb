require 'media'
require 'media/video'
require 'media/uploader'
require 'media/allowed_duration_range'
require 'media/video/editing/cmd/extract_frame'
require 'media/video/editing/conversion'
require 'media/video/editing/conversion/job'
require 'media/image/editing/resize_to_fill'

module Media
  module Video
    class Uploader < Uploader

      require 'media/video/uploader/validation'

      include Validation

      PUBLIC_RELATIVE_FOLDER        = env_relative_path 'media_elements/videos'
      ABSOLUTE_FOLDER               = File.join RAILS_PUBLIC, PUBLIC_RELATIVE_FOLDER
      EXTENSION_WHITE_LIST          = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)
      EXTENSION_WHITE_LIST_WITH_DOT = EXTENSION_WHITE_LIST.map{ |ext| ".#{ext}" }
      MIN_DURATION                  = 1
      DURATION_THRESHOLD            = CONFIG.video.duration_threshold
      FORMATS                       = FORMATS
      ALLOWED_KEYS                  = [:filename] + FORMATS
      VERSION_FORMATS               = VERSION_FORMATS
      CONVERSION_CLASS              = Editing::Conversion

      private
      def extract_versions(infos)
        cover_path = File.join output_folder, COVER_FORMAT % processed_original_filename_without_extension
        extract_cover @converted_files[:mp4], cover_path, infos[:mp4].duration

        thumb_path = File.join output_folder, THUMB_FORMAT % processed_original_filename_without_extension
        extract_thumb cover_path, thumb_path, *THUMB_SIZES
      end

      def extract_cover(input, output, duration)
        seek = duration / 2
        Editing::Cmd::ExtractFrame.new(input, output, seek).run!
        raise StandardError, 'unable to create cover' unless File.exists? output
      end

      def extract_thumb(input, output, width, height)
        Image::Editing::ResizeToFill.new(input, output, width, height).run
      end
    end
  end
end
