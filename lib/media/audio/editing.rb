require 'media'
require 'media/audio'
require 'recursive_open_struct'
require 'env_relative_path'

module Media
  module Audio
    module Editing
      SOX_BIN            = CONFIG.sox.cmd.bin
      SOX_GLOBAL_OPTIONS = CONFIG.sox.cmd.global_options
    end
  end
end