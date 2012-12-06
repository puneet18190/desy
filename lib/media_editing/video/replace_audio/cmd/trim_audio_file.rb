require 'media_editing/video'
require 'media_editing/video/replace_audio'
require 'media_editing/video/replace_audio/cmd'
require 'media_editing/video/cmd/sox'
require 'shellwords'

# Per ora non è utilizzata, ma servirà in fase di editor audio
module MediaEditing
  module Video
    class ReplaceAudio
      class Cmd
        class TrimAudioFile < MediaEditing::Video::Cmd::Sox

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