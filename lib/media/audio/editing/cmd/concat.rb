require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/audio/editing/cmd'
require 'media/audio/editing/cmd/sox'
require 'shellwords'

module Media
  module Audio
    module Editing
      class Cmd
        class Concat < Cmd::Sox

          UNSUPPORTED_FORMATS = [:m4a]
  
          def initialize(audios_with_paddings, output, format = nil)
            @audios_with_paddings, @output, @format = audios_with_paddings, output, format
          end
  
          private
          def cmd!
            output = @output.shellescape
            audios_with_paddings_length = @audios_with_paddings.length
  
            cmd_entries = @audios_with_paddings.each_with_index.map do |(audio, paddings), i|
              cmd_entry(audio.shellescape, output, audios_with_paddings_length, paddings, i)
            end

            # ( ( avconv -i c1.m4a -f sox - | sox -p -p pad 5 5) ; ( avconv -i c2.m4a -f sox - | sox -p -p pad 5 5 ); ( avconv -i c1.m4a -f sox - | sox -p pad 5 5 ) ; ( avconv -i c2.m4a -f sox - | sox -p -p pad 5 5 ) ) | sox -p -p | avconv -f sox -i - -strict experimental -c:a aac prova.m4a
            if unsupported_format?
              "( #{cmd_entries.join(' ; ')} ) | sox -p -p | avconv -f sox -i - -strict experimental -c:a aac #{output}"
            else
              cmd_entries.join(' | ')
            end
          end

          def cmd_entry(input, output, audios_with_paddings_length, paddings, i)
            pad = sox_pad(paddings)

            if unsupported_format?
              pad_with_pipe = pad ? "| #{pad} " : ''
              "( avconv -i #{input} -f sox - #{pad_with_pipe})"
            else
              cmds = [ BIN_AND_GLOBAL_OPTIONS, sox_input(input, i), sox_output(output, audios_with_paddings_length, i) ]
              pad ? cmds << pad : cmds
              cmds.join(' ')
            end
          end
  
          def sox_input(input, i)
            # se è il primo è un input normale, altrimenti è una sox pipe
            i == 0 ? input : "-p #{input}"
          end
  
          def sox_output(output, audios_with_paddings_length, i)
            # se è l'ultimo è una audio pipe, altrimenti è una sox pipe
            i == audios_with_paddings_length-1 ? output : '-p'
          end

          def sox_pad(paddings)
            if paddings
              lpad, rpad = paddings
              if lpad > 0 || rpad > 0
                lpad, rpad = lpad.round(2).to_s.shellescape, rpad.round(2).to_s.shellescape
                "pad #{lpad} #{rpad}"
              end
            end
          end

          def unsupported_format?
            case @format
            when *UNSUPPORTED_FORMATS then true
            else                           false
            end
          end
  
        end
      end
    end
  end
end
