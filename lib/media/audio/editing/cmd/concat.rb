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
  
          def initialize(audios_with_paddings, output)
            @audios_with_paddings, @output = audios_with_paddings, output
          end
  
          private
          def cmd!
            output = @output.shellescape
            audios_with_paddings_length = @audios_with_paddings.length
  
            @audios_with_paddings.each_with_index.map do |(audio, paddings), i|
              audio = audio.shellescape

              sox_input  = sox_input(i, audio)
              sox_output = sox_output(audios_with_paddings_length, i, output)
              sox_pad    = 
                if paddings
                  lpad, rpad = paddings
                  if lpad > 0 || rpad > 0
                    lpad, rpad = lpad.round(2).to_s.shellescape, rpad.round(2).to_s.shellescape
                    "pad #{lpad} #{rpad}"
                  end
                end

              cmds = [BIN_AND_GLOBAL_OPTIONS, sox_input, sox_output]
              cmds << sox_pad if sox_pad
              cmds.join(' ')
  
            end.join(' | ')
          end
  
          def sox_input(i, input)
            # se è il primo è un input normale, altrimenti è una sox pipe
            if i == 0
              input
            else
              "-p #{input}"
            end
          end
  
          def sox_output(audios_with_paddings_length, i, output)
            # se è l'ultimo è una audio pipe, altrimenti è una sox pipe
            if i+1 == audios_with_paddings_length
              output
            else
              '-p'
            end
          end
  
        end
      end
    end
  end
end
