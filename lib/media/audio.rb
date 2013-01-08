require 'media'

module Media
  module Audio
    FORMATS         = CONFIG.avtools.avconv.audio.formats.marshal_dump.keys
    VERSION_FORMATS = {}
  end
end

require 'media/audio/uploader'
require 'media/audio/editing'