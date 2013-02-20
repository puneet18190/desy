require 'media'
require 'media/audio'
require 'media/audio/uploader'

module Media
  module Audio
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
          elsif @value.instance_of?(String)
            if column_changed? and not rename?
              'renaming denied'
            end
          else
            'unsupported upload'
          end
        end

        private
        def error_message_for_file_to_convert
          if not self.class::EXTENSION_WHITE_LIST_WITH_DOT.include?(original_filename_extension)
            'unsupported format'
          else
            info = Info.new(@original_file.path, false)
            if not info.valid?
              'invalid audio'
            elsif info.duration < self.class::MIN_DURATION
              'invalid duration'
            end
          end
        end

        def error_message_for_converted_files
          mp3_path, ogg_path = @converted_files[:mp3], @converted_files[:ogg]
          if !@original_filename_without_extension.is_a?(String)
            'invalid filename'
          elsif !mp3_path.instance_of?(String) || !ogg_path.instance_of?(String)
            'invalid paths'
          elsif [mp3_path, ogg_path].map{ |p| File.extname(p) } != %w(.mp3 .ogg)
            'invalid extension'
          elsif !(mp3_info = Info.new(mp3_path, false)).valid? || !(ogg_info = Info.new(ogg_path, false)).valid?
            'invalid audio'
          elsif [mp3_info.duration, ogg_info.duration].min < self.class::MIN_DURATION
            'invalid duration'
          elsif not allowed_duration_range?(mp3_info.duration, ogg_info.duration)
            'invalid duration difference'
          end
        end
      end
    end
  end
end
