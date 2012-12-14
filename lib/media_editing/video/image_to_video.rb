require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/logging'
require 'media_editing/in_tmp_dir'
require 'media_editing/video/cmd/image_to_video'
require 'mini_magick'

module MediaEditing
  module Video
    class ImageToVideo

      include MediaEditing::Video::Logging
      include MediaEditing::Video::InTmpDir

      PROCESSED_IMAGE_PATH_FORMAT = 'processed_image.%s'

      attr_reader :input_path, :output_without_extension, :duration

      def initialize(input_path, output_without_extension, duration)
        @input_path               = input_path
        @output_without_extension = output_without_extension
        @duration                 = duration
        raise Error.new('duration must be a Numeric > 0', duration: duration) unless duration.is_a? Numeric and duration > 0
      end

      def run
        in_tmp_dir do
          processed_image_path = tmp_path( PROCESSED_IMAGE_PATH_FORMAT % File.extname(input_path) )
          image_process(processed_image_path)

          mp4_conversion  = Thread.new { convert_to(processed_image_path, :mp4)  }
          webm_conversion = Thread.new { convert_to(processed_image_path, :webm) }

          mp4_conversion.abort_on_exception = webm_conversion.abort_on_exception = true

          # Say to the parent thread (me) to wait the children threads to finish before to continue
          mp4_conversion.join
          webm_conversion.join

          mp4_file_info  = MediaEditing::Video::Info.new mp4_output_path
          webm_file_info = MediaEditing::Video::Info.new webm_output_path

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

        log_folder = create_log_folder
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
          cmd.resize  "#{MediaEditing::Video::AVCONV_OUTPUT_WIDTH}x#{MediaEditing::Video::AVCONV_OUTPUT_HEIGHT}^"
          cmd.gravity 'center'
          cmd.extent  "#{MediaEditing::Video::AVCONV_OUTPUT_WIDTH}x#{MediaEditing::Video::AVCONV_OUTPUT_HEIGHT}"
        end
        input.write(processed_image_path)
      end

    end
  end
end