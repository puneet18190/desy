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
        :renaming_denied if column_changed? and not rename?
      else
        :unsupported_upload
      end
    end

    private
    def error_message_for_file_to_convert
      path, extension = @original_file.path, original_filename_extension
      if not EXTENSIONS_WHITE_LIST_WITH_DOT.include?(extension)
        :unsupported_format
      elsif not info = MediaEditing::Video::Info.new(path, false)
        :invalid_video
      elsif info.duration < MIN_DURATION
        :invalid_duration
      end
    end

    def error_message_for_converted_files
      mp4_path, webm_path = @converted_files[:mp4], @converted_files[:webm]
      if @original_filename_without_extension.blank?
        :invalid_filename
      elsif [mp4_path, webm_path].map{ |p| File.extname(p) } != %w(.mp4 .webm)
        :invalid_extension
      elsif !(mp4_info = MediaEditing::Video::Info.new(mp4_path, false)) || !(webm_info = MediaEditing::Video::Info.new(webm_path, false))
        :invalid_video
      elsif [mp4_info.duration, webm_info.duration].min < MIN_DURATION
        :invalid_duration
      elsif not allowed_duration_range?(mp4_info.duration, webm_info.duration)
        :invalid_duration_difference
      end
    end
  end
end