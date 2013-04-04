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

        OUTPUT_M4A_FORMAT = '%s.m4a'
        OUTPUT_OGG_FORMAT = '%s.ogg'
        
        # Usage example:
        #
        # Concat.new([ { ogg: 'input.ogg', m4a: 'input.m4a'}, { ogg: 'input2.ogg', m4a: 'input2.m4a'} ], '/output/without/extension').run 
        #
        #   #=> { m4a:'/output/without/extension.m4a', ogg:'/output/without/extension.ogg' }
        #
        def initialize(inputs, output_without_extension, log_folder = nil)
          unless inputs.is_a?(Array) &&
                 inputs.present?     &&
                 inputs.all? do |input|
                   input.is_a?(Hash)                 &&
                   input.keys.sort == FORMATS.sort   &&
                   input.values.size == FORMATS.size &&
                   input.values.all?{ |v| v.is_a? String }
                 end
            raise Error.new( "inputs must be an array with at least one element and its elements must be hashes with #{FORMATS.inspect} as keys and strings as values", 
                             inputs: inputs, output_without_extension: output_without_extension )
          end
  
          unless output_without_extension.is_a?(String)
            raise Error.new('output_without_extension must be a string', output_without_extension: output_without_extension)
          end
  
          @inputs, @output_without_extension = inputs, output_without_extension
          
          if m4a_inputs.size != ogg_inputs.size
            raise Error.new('m4a_inputs and ogg_inputs must be of the same size', inputs: @inputs, output_without_extension: @output_without_extension)
          end

          @log_folder = log_folder
        end

        def run
          # Posso controllare m4a_inputs per sapere quante coppie di video ho, perché ho già visto che m4a_inputs.size == ogg_inputs.size
          # Caso speciale: se ho una sola coppia di input copio i due video nei rispettivi output e li ritorno
          return copy_first_inputs_to_outputs if m4a_inputs.size == 1
          
          in_tmp_dir { Thread.join *FORMATS.map { |format| proc{ concat(format) } } }
          outputs
        end

        private
        def concat(format)
          create_log_folder
          Cmd::Concat.new(inputs[format], outputs[format]).run! *logs
        end
        
        def m4a_output
          OUTPUT_M4A_FORMAT % @output_without_extension
        end

        def ogg_output
          OUTPUT_OGG_FORMAT % @output_without_extension
        end

        def outputs
          { m4a: m4a_output, ogg: ogg_output }
        end

        def inputs
          @_inputs ||= Hash[ FORMATS.map{ |f| [f, @inputs.map{ |input| input[f] } ] } ]
        end

        def m4a_inputs
          @inputs.map{ |input| input[:m4a] }
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