require 'media_editing'
require 'media_editing/video'

module MediaEditing
  module Video
    class Error < StandardError

      def initialize(msg, data = {})
        @msg, @data = msg, data
      end

      def to_s
        "#{@msg}#{data}"
      end

      private

      def data
        @data.map{ |k, v| "\n  #{k}: #{v.is_a?(String) ? v : v.inspect}" }.join ''
      end

    end
  end
end