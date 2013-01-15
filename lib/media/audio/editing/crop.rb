require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/video/editing/crop'
require 'media/logging'
require 'media/audio/editing/cmd/crop'

module Media
  module Audio
    module Editing
      class Crop < Video::Editing::Crop
  
        include Logging

        FORMATS  = FORMATS
        CROP_CMD = Cmd::Crop
      end
    end
  end
end
