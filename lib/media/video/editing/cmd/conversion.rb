require 'media/video/editing'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'media/video/editing/cmd/avconv'
require 'media/video/editing/error'

module Media
  module Video
    module Editing
      class Cmd
        class Conversion < Cmd::Avconv
  
          OW, OH, OAR = AVCONV_OUTPUT_WIDTH, AVCONV_OUTPUT_HEIGHT, AVCONV_OUTPUT_ASPECT_RATIO
          SH_VARS     = Hash[ CONFIG.avtools.avconv.cmd.sh_vars.marshal_dump.map{ |k, v| [k.to_s, v] } ]
          BIN         = CONFIG.avtools.avconv.cmd.bin
  
          @subexec_options = superclass.subexec_options.merge(sh_vars: SH_VARS)
          @bin             = BIN
  
          def initialize(input_file, output_file, format, input_file_info = nil)
            super([input_file], output_file, format)
  
            @input_file_info = input_file_info || Info.new(input_file)
            if vstreams.empty?
              raise Error.new( 'at least one video stream must be present', 
                               input_file: input_file, output_file: output_file, format: format, input_file_info: input_file_info )
            end
            
            output_options [ vcodec, acodec, vmap, amap, vfilters ]
          end
  
          private
        
          # The goal here is to resize the input video keeping the original ratio to a size 
          # which fills in OUTPUT_WIDTH and OUTPUT_HEIGHT values, and then eventually crop 
          # the parts of the input video which exceed in order to obtain an output video of
          # OUTPUT_WIDTH and OUTPUT_HEIGHT sizes.
          #
          # In order to reach our goal, we apply two avconv filters; in order to understand 
          # how they work, you should read carefully AVConv manual before (`man avconv`), 
          # expecially sections 'EXPRESSION EVALUATION' and 'VIDEO FILTERS'.
          # 
          # We apply two filters:
          #
          #   scale:
          #     output width:
          #       lt(iw/ih\,#{OAR})    #=> if input_width/input_height is less than the output aspect ratio
          #       *#{OW}               #=> then resize width to OUTPUT_WIDTH
          #       +gte(iw/ih\\,#{OAR}) #=> else if input_width/input_height is greater than or equal to the output aspect ratio
          #       *-1                  #=> then resize width to a value which maintains the aspect ratio of the input video
          #     output height:
          #       lt(iw/ih\,#{OAR})    #=> if input_width/input_height is less than the output aspect ratio
          #       *-1                  #=> then resize height to a value which maintains the aspect ratio of the input video
          #       +gte(iw/ih\\,#{OAR}) #=> else if input_width/input_height is greater than or equal to the output aspect ratio
          #       *#{OH}               #=> then resize height to OUTPUT_HEIGHT
          #   crop:
          #     output width and output height:
          #       #{OW}:#{OH}         #=> set respectively equal to OUTPUT_WIDTH and OUTPUT_HEIGHT
          #     crop x and crop y:
          #       (iw-OW)/2:(ih-OH)/2 #=> sets the position of the top-left corner of the output in order to center the video
          def vfilters
            %Q[-vf 'scale=lt(iw/ih\\,#{OAR})*#{OW}+gte(iw/ih\\,#{OAR})*-1:lt(iw/ih\\,#{OAR})*-1+gte(iw/ih\\,#{OAR})*#{OH},crop=#{OW}:#{OH}:(iw-ow)/2:(ih-oh)/2']
          end
  
          def vstreams
            @input_file_info.video_streams
          end
  
          def astreams
            @input_file_info.audio_streams
          end
  
          def vmap
            '-map 0:v:0'
          end
  
          def amap
            astreams.present? ? '-map 0:a:0' : nil
          end
          
        end
      end
    end
  end
end
