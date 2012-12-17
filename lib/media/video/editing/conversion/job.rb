require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/video/editing/conversion'

module Media
  module Video
    module Editing
      class Conversion
        class Job < Struct.new(:uploaded_path, :output_path_without_extension, :original_filename, :model_id)
          def perform
            Conversion.new(uploaded_path, output_path_without_extension, original_filename, model_id).run
          end
        end
      end
    end
  end
end
