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

      self.public_relative_folder        = env_relative_path 'media_elements/videos'
      self.absolute_folder               = File.join RAILS_PUBLIC, public_relative_folder
      self.extension_white_list          = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)
      self.extension_white_list_with_dot = extension_white_list.map{ |ext| ".#{ext}" }
      self.min_duration                  = 1
      self.duration_threshold            = CONFIG.video.duration_threshold
      self.formats                       = FORMATS
      self.allowed_keys                  = [:filename] + formats
      self.version_formats               = VERSION_FORMATS
      self.conversion_class              = Editing::Conversion

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
