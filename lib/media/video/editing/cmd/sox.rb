require 'media_editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/avconv'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class Sox < Cmd
        BIN                    = SOX_BIN.shellescape
        GLOBAL_OPTIONS         = SOX_GLOBAL_OPTIONS.map(&:shellescape).join(' ')
        BIN_AND_GLOBAL_OPTIONS = "#{BIN} #{GLOBAL_OPTIONS}"
      end
    end
  end
end