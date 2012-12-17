require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/audio/editing/conversion'

module Media
  module Audio
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