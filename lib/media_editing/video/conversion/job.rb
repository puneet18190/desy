require 'media_editing/video'

module MediaEditing
  module Video
    class Conversion
      class Job < Struct.new(:model_id, :filename, :uploaded_path)
        def perform
          MediaEditing::Video::Conversion.new(model_id, filename, uploaded_path).run
        end
      end
    end
  end
end