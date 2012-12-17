require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/cmd/avconv'
require 'shellwords'
require 'subexec'

module Media
  module Video
    module Editing
      class Cmd
        class Avconv < Avconv
        end
      end
    end
  end
end
