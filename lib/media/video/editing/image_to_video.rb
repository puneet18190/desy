require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/logging'
require 'media/in_tmp_dir'
require 'media/info'
require 'media/video/editing/cmd/image_to_video'
require 'mini_magick'
require 'media/thread'

module Media
  module Video
    module Editing
      class ImageToVideo
  
        include Logging
        include InTmpDir
  
        PROCESSED_IMAGE_PATH_FORMAT = 'processed_image.%s'
  
        attr_reader :input_path, :output_without_extension, :duration
  
        def initialize(input_path, output_without_extension, duration, log_folder = nil)
          raise Error.new('duration must be a Numeric > 0', duration: duration) unless duration.is_a? Numeric and duration > 0

          @duration, @input_path, @output_without_extension = duration, input_path, output_without_extension

          @log_folder = log_folder
        end
  
        def run
          in_tmp_dir do
            processed_image_path = tmp_path( PROCESSED_IMAGE_PATH_FORMAT % File.extname(input_path) )
            image_process(processed_image_path)
  
            Thread.join *FORMATS.map{ |format| proc{ convert_to(processed_image_path, format) } }

            mp4_file_info  = Info.new mp4_output_path
            webm_file_info = Info.new webm_output_path
  
            if mp4_file_info.duration != webm_file_info.duration
              raise Error.new( 'output videos have not the same duration',
                               input_path: input_path, processed_image_path: processed_image_path,
                               mp4_output_path: mp4_output_path, webm_output_path: webm_output_path,
                               mp4_duration: mp4_file_info.duration, webm_duration: webm_file_info.duration )
            end
          end
          { webm: webm_output_path, mp4: mp4_output_path }
        end
  
        private
        def convert_to(processed_image_path, format)
          output_path = output_path(format)
  
          create_log_folder
          stdout_log, stderr_log = stdout_log(format), stderr_log(format)
          cmd        = Cmd::ImageToVideo.new(processed_image_path, output_path, format, duration)
          subexec    = cmd.run %W(#{stdout_log} a), %W(#{stderr_log} a)
          exitstatus = subexec.exitstatus
  
          if exitstatus != 0
            raise Error.new('conversion process failed', format: format, cmd: cmd, exitstatus: exitstatus) 
          end
        end
  
        def mp4_output_path
          output_path(:mp4)
        end
  
        def webm_output_path
          output_path(:webm)
        end
  
        def output_path(format)
          "#{output_without_extension}.#{format}"
        end
  
        def input
          @input ||= MiniMagick::Image.open(input_path)
        end
  
        def input_width
          input[:width]
        end
  
        def input_height
          input[:height]
        end
  
        # resize and crop
        def image_process(processed_image_path)
          input.combine_options do |cmd|
            cmd.resize  "#{AVCONV_OUTPUT_WIDTH}x#{AVCONV_OUTPUT_HEIGHT}^"
            cmd.gravity 'center'
            cmd.extent  "#{AVCONV_OUTPUT_WIDTH}x#{AVCONV_OUTPUT_HEIGHT}"
          end
          input.write(processed_image_path)
        end
  
      end
    end
  end
end
