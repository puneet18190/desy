require 'video_uploader'

class VideoUploader
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
          :invalid_filename
        end
      else
        'unsupported upload'
      end
    end

    private
    def error_message_for_file_to_convert
      return :invalid_filename if processed_original_filename_without_extension.blank?
        
      if not EXTENSIONS_WHITE_LIST_WITH_DOT.include?(original_filename_extension)
        :unsupported_format
      else
        info = MediaEditing::Info.new(@original_file.path, false)
        if not info.valid?
          :invalid_video
        elsif info.duration < MIN_DURATION
          :invalid_duration
        end
      end
    end

    def error_message_for_converted_files
      mp4_path, webm_path = @converted_files[:mp4], @converted_files[:webm]
      if !@original_filename_without_extension.is_a?(String) || process(@original_filename_without_extension).blank?
        :invalid_filename
      elsif [mp4_path, webm_path].map{ |p| File.extname(p) } != %w(.mp4 .webm)
        'invalid extension'
      elsif !(mp4_info = MediaEditing::Info.new(mp4_path, false)).valid? || !(webm_info = MediaEditing::Info.new(webm_path, false)).valid?
        'invalid video'
      elsif [mp4_info.duration, webm_info.duration].min < MIN_DURATION
        'invalid duration'
      elsif not allowed_duration_range?(mp4_info.duration, webm_info.duration)
        'invalid duration difference'
      end
    end
  end
end
