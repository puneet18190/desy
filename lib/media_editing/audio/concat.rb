require 'media_editing'
require 'media_editing/audio'


module MediaEditing
  module Audio
    class Concat

      FORMATS = %w(mp3 ogg)

      def initialize(inputs, output_without_extension)
        unless inputs.is_a?(Hash)                                                     and 
               inputs.keys.sort == FORMATS.sort                                       and
               inputs.values.all?{ |v| v.is_a? Array }                                and
               inputs.values.map{ |v| v.all?{ |_v| _v.is_a? String } }.uniq == [true]
          raise MediaEditing::Audio::Error.new("inputs must be an Hash with #{FORMATS.inspect} as keys and an array of strings as values with at least one value", inputs: inputs, output_without_extension: output_without_extension)
        end

        unless output_without_extension.is_a?(String)
          raise MediaEditing::Audio::Error.new('output_without_extension must be a string', output_without_extension: output_without_extension)
        end

        @inputs, @output_without_extension = inputs, output_without_extension
        
        if mp4_inputs.size != webm_inputs.size
          raise MediaEditing::Audio::Error.new('inputs[:mp4] and inputs[:webm] must be of the same size', inputs: @inputs, output_without_extension: @output_without_extension)
        end
      end
    end
  end
end