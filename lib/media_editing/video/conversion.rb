require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/logging'
require 'media_editing/video/allowed_duration_range'
require 'media_editing/video/info'
require 'media_editing/video/error'
require 'media_editing/video/cmd/conversion'
require 'env_relative_path'

module MediaEditing
  module Video
  # WARNING!!!
  # avconv requires the package libavcodec-extra-53 to be installed for the libx264 codec
    class Conversion

      include EnvRelativePath
      include MediaEditing::Video::Logging
      include MediaEditing::Video::AllowedDurationRange

      INPUT_FOLDER       = Rails.root.join(env_relative_path('tmp/media_editing/video/conversions')).to_s
      DURATION_THRESHOLD = MediaEditing::Video::CONFIG.duration_threshold

      def self.log_folder
        super 'conversions'
      end

      attr_reader :model_id, :uploaded_file

      # Example: new(13, '/path/to/valid video.flv', '/path/to/desy/public/media_elements/13/valid-video')
      def initialize(model_id, uploaded_file, output_path_without_extension)
        @model_id = model_id
        init_model

        @uploaded_file = uploaded_file
        @output_path_without_extension = output_path_without_extension
      end

      def run
        begin
          mp4_conversion  = Thread.new { convert_to(:mp4)  }
          webm_conversion = Thread.new { convert_to(:webm) }

          mp4_conversion.abort_on_exception = webm_conversion.abort_on_exception = true

          # Say to the parent thread (me) to wait the threads to finish before to continue
          mp4_conversion.join
          webm_conversion.join

          mp4_file_info  = MediaEditing::Video::Info.new output_file(:mp4)
          webm_file_info = MediaEditing::Video::Info.new output_file(:webm)

          unless allowed_duration_range?(mp4_file_info.duration, webm_file_info.duration) 
            raise MediaEditing::Video::Error.new( 'output videos have different duration', 
                                           model_id: model_id, mp4_duration: mp4_file_info.duration, webm_duration: webm_file_info.duration )
          end

          extract_cover output_file(:mp4), "#{@output_path_without_extension}-cover.jpg", mp4_file_info.duration / 2
        rescue StandardError => e
          model.update_attribute(:converted, false) if model.present?
          FileUtils.rm_rf output_folder if Dir.exists? output_folder
          raise e
        end

        model.converted     = true
        model.rename_media  = true
        model.mp4_duration  = mp4_file_info.duration
        model.webm_duration = webm_file_info.duration
        model.media         = output_filename_without_extension
        model[:media]       = output_filename_without_extension
        model.save!

        FileUtils.rm input_file
      end

      def extract_cover(input, output, seek)
        Cmd::ExtractFrame.new(input, output, seek).run! %W(#{stdout_log} a), %W(#{stderr_log} a)
        unless File.exists? output
          raise MediaEditing::Video::Error.new( 'unable to create cover',
                                         model_id: model_id, input: input, output: output, stdout_log: stdout_log, stderr_log: stderr_log)
        end
      end

      def convert_to(format)
        if not File.exists? uploaded_file and not File.exists? input_file
          raise MediaEditing::Video::Error.new( "at least one between uploaded_file and input_file must exist", 
                                         input_file: input_file, uploaded_file: uploaded_file, format: format )
        end

        FileUtils.mkdir_p input_folder unless Dir.exists? input_folder

        # If input_file already exists, I assume that someone has already processed it before;
        # so I use it (I use it as cache)
        FileUtils.mv uploaded_file, input_file unless File.exists? input_file

        FileUtils.mkdir_p output_folder unless Dir.exists? output_folder
        
        begin
          output_file = output_file(format)

          log_folder = create_log_folder
          stdout_log, stderr_log = stdout_log(format), stderr_log(format)

          Cmd::Conversion.new(input_file, output_file, format).run! %W(#{stdout_log} a), %W(#{stderr_log} a)
        rescue StandardError => e
          FileUtils.rm_rf output_folder if Dir.exists? output_folder
          raise e
        end

      end

      private
      def input_file
        File.join input_folder, output_filename_without_extension
      end

      def output_file(format)
        "#{@output_path_without_extension}.#{format}"
      end

      def output_filename_without_extension
        File.basename @output_path_without_extension
      end

      def output_folder
        File.dirname @output_path_without_extension
      end

      def input_folder
        File.join INPUT_FOLDER, model_id.to_s
      end

      def log_folder(_ = nil)
        super model_id.to_s
      end

      def model
        @model ||= ::Video.find model_id
      end
      alias init_model model

    end
  end
end