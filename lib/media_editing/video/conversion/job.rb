require 'media_editing/video'

module MediaEditing
  module Video
    class Conversion
      class Job < Struct.new(:uploaded_path, :output_path_without_extension, :original_filename, :model_id)
        def perform
          MediaEditing::Video::Conversion.new(uploaded_path, output_path_without_extension, original_filename, model_id).run
        end
      end
    end
  end
end