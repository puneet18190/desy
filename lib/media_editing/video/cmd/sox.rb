require 'media_editing/video'
require 'media_editing/video/cmd'
module MediaEditing
  module Video
    class Cmd
      class Sox < MediaEditing::Video::Cmd
        BIN                    = MediaEditing::Video::SOX_BIN.shellescape
        GLOBAL_OPTIONS         = MediaEditing::Video::SOX_GLOBAL_OPTIONS.map(&:shellescape).join(' ')
        BIN_AND_GLOBAL_OPTIONS = "#{BIN} #{GLOBAL_OPTIONS}"
      end
    end
  end
end