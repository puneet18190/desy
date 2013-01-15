require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/video/editing/cmd/crop'

module Media
  module Video
    module Editing
      class Crop
  
        include Logging
  
        def initialize(inputs, output_without_extension, start, duration)
          unless inputs.is_a?(Hash)                       and 
                 inputs.keys.sort == FORMATS.sort         and
                 inputs.values.all?{ |v| v.is_a? String }
            raise Error.new("inputs must be an Hash with #{FORMATS.inspect} as keys and strings as values", inputs: inputs)
          end
  
          unless output_without_extension.is_a?(String)
            raise Error.new('output_without_extension must be a String', output_without_extension: output_without_extension)
          end
  
          unless start.is_a?(Numeric) and start >= 0
            raise Error.new('start must be a Numeric >= 0', start: start)
          end
  
          unless duration.is_a?(Numeric) and duration > 0
            raise Error.new('duration must be a Numeric > 0', duration: duration)
          end
  
          @inputs, @output_without_extension, @start, @duration = inputs, output_without_extension, start, duration
        end
  
        def run
          create_log_folder
  
          @inputs.map do |format, input|
            SensitiveThread.new do
              Cmd::Crop.new(input, output(format), @start, @duration, format).run! *logs
            end
          end.each(&:join)
  
          outputs
        end
  
        private
        def output(format)
          "#{@output_without_extension}.#{format}"
        end
  
        def outputs
          Hash[ FORMATS.map{ |format| [format, output(format)] } ]
        end
      end
    end
  end
end
