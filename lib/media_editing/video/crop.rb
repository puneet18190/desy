require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/cmd/crop'

module MediaEditing
  module Video
    class Crop

      include MediaEditing::Video::Logging

      FORMATS = MediaEditing::Video::FORMATS

      def initialize(inputs, output_without_extension, start, duration)
        unless inputs.is_a?(Hash)                       and 
               inputs.keys.sort == FORMATS.sort         and
               inputs.values.all?{ |v| v.is_a? String }
          raise MediaEditing::Video::Error.new("inputs must be an Hash with #{FORMATS.inspect} as keys and strings as values", inputs: inputs)
        end

        unless output_without_extension.is_a?(String)
          raise MediaEditing::Video::Error.new('output_without_extension must be a String', output_without_extension: output_without_extension)
        end

        unless start.is_a?(Numeric) and start >= 0
          raise MediaEditing::Video::Error.new('start must be a Numeric >= 0', start: start)
        end

        unless duration.is_a?(Numeric) and duration > 0
          raise MediaEditing::Video::Error.new('duration must be a Numeric > 0', duration: duration)
        end

        @inputs, @output_without_extension, @start, @duration = inputs, output_without_extension, start, duration
      end

      def run
        create_log_folder

        @inputs.map do |format, input|
          Thread.new do
            Cmd::Crop.new(input, output(format), @start, @duration, format).run! *logs
          end.tap{ |t| t.abort_on_exception = true }
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