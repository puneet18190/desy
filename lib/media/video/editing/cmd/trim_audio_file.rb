require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/sox'
require 'shellwords'

# Per ora non è utilizzata, ma servirà in fase di editor audio
module Media
  module Video
    module Editing
      class Cmd
        class TrimAudioFile < Cmd::Sox
  
          def initialize(input, output, ltrim, rtrim)
            @input, @output, @ltrim, @rtrim = input, output, ltrim, rtrim
          end
  
          private
          def cmd!
            "#{BIN_AND_GLOBAL_OPTIONS} #{input} #{output} trim #{ltrim} #{rtrim}"
          end
  
          def input
            @input.shellescape
          end
  
          def output
            @output.shellescape
          end
  
          def ltrim
            shellescaped_trim(@ltrim)
          end
  
          def rtrim
            shellescaped_trim(@rtrim)
          end
  
          def shellescaped_trim(value)
            value.round(2).to_s.shellescape
          end
  
        end
      end
    end
  end
end
