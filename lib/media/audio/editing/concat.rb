require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/logging'
require 'media/in_tmp_dir'
require 'media/thread'

module Media
  module Audio
    module Editing
      class Concat

        include Logging
        include InTmpDir

        OUTPUT_MP3_FORMAT = '%s.mp3'
        OUTPUT_OGG_FORMAT = '%s.ogg'
        
        # Usage example:
        #
        # Concat.new([ { webm: 'input.webm', mp4: 'input.mp4'}, { webm: 'input2.webm', mp4: 'input2.mp4'} ], '/output/without/extension').run 
        #
        #   #=> { mp4:'/output/without/extension.mp4', webm:'/output/without/extension.webm' }
        #
        def initialize(inputs, output_without_extension)
          unless inputs.is_a?(Array) and
                 inputs.present?     and
                 inputs.all? do |input|
                   input.instance_of?(Hash)          and
                   input.keys.sort == FORMATS.sort   and
                   input.values.size == FORMATS.size and
                   input.values.all?{ |v| v.instance_of? String }
                 end
            raise Error.new( "inputs must be an array with at least one element and its elements must be hashes with #{FORMATS.inspect} as keys and strings as values", 
                             inputs: inputs, output_without_extension: output_without_extension )
          end
  
          unless output_without_extension.is_a?(String)
            raise Error.new('output_without_extension must be a string', output_without_extension: output_without_extension)
          end
  
          @inputs, @output_without_extension = inputs, output_without_extension
          
          if mp3_inputs.size != ogg_inputs.size
            raise Error.new('mp3_inputs and ogg_inputs must be of the same size', inputs: @inputs, output_without_extension: @output_without_extension)
          end
        end

        def run
          # Posso controllare mp3_inputs per sapere quante coppie di video ho, perché ho già visto che mp3_inputs.size == webm_inputs.size
          # Caso speciale: se ho una sola coppia di input copio i due video nei rispettivi output e li ritorno
          return copy_first_inputs_to_outputs if mp3_inputs.size == 1
          
          in_tmp_dir { Thread.join *FORMATS.map { |format| proc{ concat(format) } } }
          outputs
        end

        private
        def concat(format)
          create_log_folder
          Cmd::Concat.new(inputs[format], outputs[format]).run! *logs
        end
        
        def mp3_output
          OUTPUT_MP3_FORMAT % @output_without_extension
        end

        def ogg_output
          OUTPUT_OGG_FORMAT % @output_without_extension
        end

        def outputs
          { mp3: mp3_output, ogg: ogg_output }
        end

        def inputs
          @_inputs ||= Hash[ FORMATS.map{ |f| [f, @inputs.map{ |input| input[f] } ] } ]
        end

        def mp3_inputs
          @inputs.map{ |input| input[:mp3] }
        end
        
        def ogg_inputs
          @inputs.map{ |input| input[:ogg] }
        end

        def copy_first_inputs_to_outputs
          Hash[
            @inputs.first.map do |format, input|
              output = outputs[format]
              FileUtils.cp input, output
              [format, output]
            end
          ]
        end
      end
    end
  end
end