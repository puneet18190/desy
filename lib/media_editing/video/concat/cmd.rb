require 'media_editing/video/cmd'
require 'media_editing/video/concat/cmd/mp4'
require 'media_editing/video/concat/cmd/webm'

module MediaEditing
  module Video
    class Concat
      module Cmd

        # FORMATS = MediaEditing::Video::FORMATS

        # def self.new(inputs, output, format)

        #   raise 'format unsupported' unless FORMATS.include? format

        #   const_get(format.capitalize).new(inputs, output)
        # end

      end
    end
  end
end