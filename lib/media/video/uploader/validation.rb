require 'media'
require 'media/video'
require 'media/video/uploader'

module Media
  module Video
    class Uploader
      module Validation
        def validation
          error_message = self.error_message
          model.errors.add :media, error_message if error_message
        end

        def error_message
          if @converted_files
            error_message_for_converted_files
          elsif @original_file
            error_message_for_file_to_convert
          elsif @value.instance_of? String
            if column_changed? and not rename?
              'renaming denied'
            elsif process(@value).blank?
              'invalid filename'
            end
          else
            'unsupported upload'
          end
        end

        private
        def error_message_for_file_to_convert
          return 'invalid filename' if processed_original_filename_without_extension.blank?
            
          if not self.class::EXTENSION_WHITE_LIST_WITH_DOT.include?(original_filename_extension)
            'unsupported format'
          else
            info = Info.new(@original_file.path, false)
            if not info.valid?
              'invalid video'
            elsif info.video_streams.blank?
              'blank video streams'
            elsif info.duration < self.class::MIN_DURATION
              'invalid duration'
            end
          end
        end

        def error_message_for_converted_files
          mp4_path, webm_path = @converted_files[:mp4], @converted_files[:webm]
          if !@original_filename_without_extension.is_a?(String) || process(@original_filename_without_extension).blank?
            'invalid filename'
          elsif [mp4_path, webm_path].map{ |p| File.extname(p) } != %w(.mp4 .webm)
            'invalid extension'
          elsif !(mp4_info = Info.new(mp4_path, false)).valid? || !(webm_info = Info.new(webm_path, false)).valid?
            'invalid video'
          elsif [mp4_info.duration, webm_info.duration].min < self.class::MIN_DURATION
            'invalid duration'
          elsif not allowed_duration_range?(mp4_info.duration, webm_info.duration)
            'invalid duration difference'
          end
        end
      end
    end
  end
end
