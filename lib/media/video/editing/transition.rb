require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/logging'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/thread'
require 'media/video/editing/cmd/video_stream_to_file'
require 'media/video/editing/cmd/extract_frame'
require 'media/video/editing/cmd/generate_transition_frames'
require 'media/video/editing/cmd/transition'
require 'pathname'

module Media
  module Video
    module Editing
      class Transition
  
        include Logging
        include InTmpDir
  
        START_FRAME         = 'start_frame.jpg'
        VIDEO_NO_AUDIO      = 'video_no_audio.mp4'
        LAST_FRAME_STEP     = -0.01
        LAST_FRAME_SKIP     = LAST_FRAME_STEP.abs*3
        END_FRAME           = 'end_frame.jpg'
        TRANSITIONS         = 'transition.jpg'
        INNER_FRAMES_AMOUNT = 23
        TRANSITIONS_FORMAT  = ( f = Pathname.new(TRANSITIONS); "#{f.basename(f.extname)}-%d#{f.extname}" ) # "transition-%d.jpg"
        FRAME_RATE          = 25
  
        def initialize(start_inputs, end_inputs, output_without_extension, log_folder = nil)
          unless start_inputs.is_a?(Hash)                       and 
                 start_inputs.keys.sort == FORMATS.sort         and
                 start_inputs.values.all?{ |v| v.is_a? String }
            raise Error.new("start_inputs must be an Hash with #{FORMATS.inspect} as keys and strings as values", start_inputs: start_inputs)
          end
  
          unless end_inputs.is_a?(Hash)                       and
                 end_inputs.keys.sort == FORMATS.sort         and
                 end_inputs.values.all?{ |v| v.is_a? String }
            raise Error.new("end_inputs must be an Hash with #{FORMATS.inspect} as keys and strings as values", end_inputs: end_inputs)
          end
  
          unless output_without_extension.is_a?(String)
            raise Error.new('output_without_extension must be a string', output_without_extension: output_without_extension)
          end
  
          @start_inputs, @end_inputs, @output_without_extension = start_inputs, end_inputs, output_without_extension
          
          @log_folder = log_folder
        end
  
        # 
        #   1. estraggo l'ultimo frame dell'input iniziale
        #   2. estraggo il primo frame dell'input finale
        #   3. genero le immagini di transizione
        #   4. genero il video utilizzando le immagini di transizione
        def run
          create_log_folder
  
          in_tmp_dir do
            start_frame = tmp_path START_FRAME
            extract_start_transition_frame(start_frame) # 1.
  
            end_frame = tmp_path END_FRAME
            extract_end_transition_frame(end_frame) # 2.
  
            transitions = tmp_path TRANSITIONS
            Cmd::GenerateTransitionFrames.new(start_frame, end_frame, transitions, INNER_FRAMES_AMOUNT).run! *logs('3_generate_transition_frames') # 3.
  
            Thread.join *FORMATS.map{ |format| proc{ transition(format) } } # 4.
          end
  
          outputs
        end
  
        private
        def transition(format)
          create_log_folder
          Cmd::Transition.new(tmp_path(TRANSITIONS_FORMAT), output(format), FRAME_RATE, format).run! *logs("4_#{format}")
        end

        def extract_start_transition_frame(output_path)
          video_duration = Info.new(@start_inputs[:mp4]).duration
          end_frame_extraction_start_seek(video_duration).step(0, LAST_FRAME_STEP) do |seek|
            Cmd::ExtractFrame.new(@start_inputs[:mp4], output_path, seek).run! *logs('1_extract_start_transition_frame')
            break if File.exists? output_path
          end

          # se non sono riuscito a tirare fuori il frame non va bene
          unless File.exists? output_path
            raise Error.new('start transition frame extraction failed', start_input_mp4: @start_inputs[:mp4])
          end
        end
  
        def extract_end_transition_frame(output_path)
          Cmd::ExtractFrame.new(@end_inputs[:mp4], output_path, 0).run! *logs('2_extract_end_transition_frame') # 2.
          
          # se non sono riuscito a tirare fuori il frame non va bene
          unless File.exists? output_path
            raise Error.new('end transition frame extraction failed', end_input_mp4: @end_inputs[:mp4])
          end
        end

        def end_frame_extraction_start_seek(duration)
          duration-LAST_FRAME_SKIP
        end
  
        def output(format)
          "#{@output_without_extension}.#{format}"
        end
  
        def outputs
          Hash[ FORMATS.map{ |format| [format, output(format)] } ]
        end
  
      end
    end
  end
end
