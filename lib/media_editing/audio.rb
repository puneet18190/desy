require 'media_editing'
require 'recursive_open_struct'
require 'env_relative_path'

module MediaEditing
  module Audio

    include EnvRelativePath

    CONFIG = RecursiveOpenStruct.new({
      formats: [:mp3, :ogg]
    })

  end
end