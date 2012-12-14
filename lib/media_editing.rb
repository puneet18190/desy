module MediaEditing
  TMP_PREFIX = "desy#{Thread.current.object_id}"
end

require 'media_editing/video'
require 'media_editing/audio'
require 'media_editing/error'
require 'media_editing/in_tmp_dir'
require 'media_editing/info'
