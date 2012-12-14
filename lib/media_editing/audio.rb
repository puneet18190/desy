require 'media_editing'
require 'recursive_open_struct'

module MediaEditing
  module Audio
    CONFIG = RecursiveOpenStruct.new({
      formats: [:mp3, :ogg]
    })
  end
end