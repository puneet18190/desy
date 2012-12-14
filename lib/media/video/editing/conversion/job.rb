require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/conversion'

module MediaEditing
  module Video
    class Conversion
      class Job < Struct.new(:uploaded_path, :output_path_without_extension, :original_filename, :model_id)
        def perform
          Conversion.new(uploaded_path, output_path_without_extension, original_filename, model_id).run
        end
      end
    end
  end
end