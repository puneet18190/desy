require 'media'

module Media
  module Video
    FORMATS = CONFIG.avtools.avconv.video.formats.marshal_dump.keys
    VERSION_FORMATS            = { cover: CONFIG.video.cover_format, thumb: CONFIG.video.thumb_format }
    COVER_FORMAT, THUMB_FORMAT = VERSION_FORMATS[:cover], VERSION_FORMATS[:thumb]
    THUMB_SIZES                = [200, 200]
  end
end