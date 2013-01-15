require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/audio/editing/cmd'
require 'shellwords'

module Media
  module Audio
    module Editing
      class Cmd
        class Sox < Cmd
          BIN                    = SOX_BIN.shellescape
          GLOBAL_OPTIONS         = SOX_GLOBAL_OPTIONS.map(&:shellescape).join(' ')
          BIN_AND_GLOBAL_OPTIONS = "#{BIN} #{GLOBAL_OPTIONS}"
        end
      end
    end
  end
end
