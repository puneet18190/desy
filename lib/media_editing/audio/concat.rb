require 'media_editing'
require 'media_editing/audio'
require 'media_editing/error'

module MediaEditing
  module Audio
    class Concat

      FORMATS = CONFIG.formats

      def initialize(inputs, output_without_extension)
        unless inputs.is_a?(Hash)                                                     and 
               inputs.keys.sort == FORMATS.sort                                       and
               inputs.values.all?{ |v| v.is_a? Array }                                and
               inputs.values.map{ |v| v.all?{ |_v| _v.is_a? String } }.uniq == [true]
          raise Error.new("inputs must be an Hash with #{FORMATS.inspect} as keys and an array of strings as values with at least one value", inputs: inputs, output_without_extension: output_without_extension)
        end

        unless output_without_extension.is_a?(String)
          raise Error.new('output_without_extension must be a string', output_without_extension: output_without_extension)
        end

        @inputs, @output_without_extension = inputs, output_without_extension
        
        if mp3_inputs.size != ogg_inputs.size
          raise Error.new('inputs[:mp3] and inputs[:ogg] must be of the same size', inputs: @inputs, output_without_extension: @output_without_extension)
        end
      end

      def run
        # Posso controllare mp3_inputs per sapere quante coppie di video ho, perché ho già visto che mp3_inputs.size == webm_inputs.size
        # Caso speciale: se ho una sola coppia di input copio i due video nei rispettivi output e li ritorno
        return copy_first_inputs_to_outputs if mp3_inputs.size == 1

        mp3_inputs_infos = mp3_inputs.map{ |input| Info.new(input) }
        paddings = paddings mp3_inputs_infos
        final_videos = nil

        in_tmp_dir do
          final_videos = concat(mp3_inputs_infos, paddings)
        end

        final_videos
      end

      private
      def mp3_output
        OUTPUT_MP3_FORMAT % @output_without_extension
      end

      def ogg_output
        OUTPUT_OGG_FORMAT % @output_without_extension
      end

      def outputs
        { mp3: mp3_output, ogg: ogg_output }
      end
    end
  end
end