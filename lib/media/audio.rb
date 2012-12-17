require 'media'

module Media
  module Audio
    FORMATS = CONFIG.avtools.avconv.audio.formats.marshal_dump.keys
  end
end

require 'media/audio/uploader'
require 'media/audio/editing'