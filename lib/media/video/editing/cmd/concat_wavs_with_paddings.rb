require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/cmd'
require 'media_editing/video/cmd/sox'
require 'shellwords'

module MediaEditing
  module Video
    class Cmd
      class ConcatWavsWithPaddings < Cmd::Sox

        def initialize(wavs_with_paddings, output)
          @wavs_with_paddings, @output = wavs_with_paddings, output
        end

        private
        def cmd!
          output = @output.shellescape
          wavs_with_paddings_length = @wavs_with_paddings.length

          cmds = shellescaped_wavs_with_paddings.each_with_index.to_a.map do |wav_with_paddings_and_i|
            wav_with_paddings, i = wav_with_paddings_and_i
            wav, paddings = wav_with_paddings

            sox_input  = sox_input(i, wav)
            sox_output = sox_output(wavs_with_paddings_length, i, output)
            sox_pad    = "pad #{paddings[0]} #{paddings[1]}"

            "#{BIN_AND_GLOBAL_OPTIONS} #{sox_input} #{sox_output} #{sox_pad}"

          end

          cmds.join(' | ')
        end

        def sox_input(i, input)
          # se è il primo è un input normale, altrimenti è una sox pipe
          if i == 0
            input
          else
            "-p #{input}"
          end
        end

        def sox_output(wavs_with_paddings_length, i, output)
          # se è l'ultimo è una wave pipe, altrimenti è una sox pipe
          if i+1 == wavs_with_paddings_length
            output
          else
            '-p'
          end
        end

        def shellescaped_wavs_with_paddings
          @wavs_with_paddings.map do |wav, paddings| 
            [ wav.shellescape, paddings.map{ |padding| padding.round(2).to_s.shellescape } ] 
          end
        end

      end
    end
  end
end