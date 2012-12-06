require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/logging'
require 'media_editing/video/info'
require 'media_editing/video/error'
require 'media_editing/video/cmd/conversion'
require 'video_uploader'

module MediaEditing
  module Video
  # WARNING!!!
  # avconv requires the package libavcodec-extra-53 to be installed for the libx264 codec
    class Conversion

      include MediaEditing::Video::Logging

      INPUT_FOLDER       = File.join Rails.root, VideoUploader.env_relative_path('tmp/video_editing/conversions')
      DURATION_THRESHOLD = 1

      Cmd = MediaEditing::Video::Cmd

      def self.log_folder
        super 'conversions'
      end

      def self.output_folder(model_id)
        VideoUploader.folder(model_id.to_s)
      end

      def initialize(model_id, original_filename, uploaded_file)
        @model_id = model_id
        init_model

        # File.basename shouldn't be necessary, but never know...
        @original_filename = File.basename original_filename
        @uploaded_file     = uploaded_file
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

          unless allowed_duration_range(mp4_file_info.duration).include? webm_file_info.duration
            raise MediaEditing::Video::Error.new( 'output videos have different duration', 
                                           model_id: model_id, mp4_duration: mp4_file_info.duration, webm_duration: webm_file_info.duration )
          end
        rescue StandardError => e
          model.update_attribute(:converted, false) if model.present?
          FileUtils.rm_rf output_folder if File.exists? output_folder
          raise e
        end

        model.converted      = true
        model.mp4_duration   = mp4_file_info.duration
        model.webm_duration  = webm_file_info.duration
        model.media          = output_filename_without_extension
        model.save

        FileUtils.rm input_file
      end

      def convert_to(format)
        if not File.exists? uploaded_file and not File.exists? input_file
          raise MediaEditing::Video::Error.new( "at least one between uploaded_file and input_file must exist", 
                                         input_file: input_file, uploaded_file: uploaded_file, format: format )
        end

        FileUtils.mkdir_p input_folder unless File.exists? input_folder

        # If input_file already exists, I assume that someone has already processed it before;
        # so I use it (I use it as cache)
        FileUtils.mv uploaded_file, input_file unless File.exists? input_file

        FileUtils.mkdir_p output_folder unless File.exists? output_folder
        
        begin
          output_file = output_file(format)

          log_folder = create_log_folder
          stdout_log, stderr_log = stdout_log(format), stderr_log(format)

          Cmd::Conversion.new(input_file, output_file, format).run! %W(#{stdout_log} a), %W(#{stderr_log} a)
        rescue StandardError => e
          FileUtils.rm_rf output_folder if File.exists? output_folder
          raise e
        end

      end

      private
      def allowed_duration_range(duration)
        (duration-DURATION_THRESHOLD)..(duration+DURATION_THRESHOLD)
      end

      def input_file
        File.join input_folder, original_filename
      end

      def original_filename
        @original_filename
      end

      def original_extension
        File.extname(original_filename)
      end

      def original_filename_without_extension
        File.basename(original_filename, original_extension)
      end

      def output_filename_without_extension
        original_filename_without_extension.parameterize
      end

      def output_file(format)
        File.join output_folder, "#{output_filename_without_extension}.#{format}"
      end

      def output_folder
        self.class.output_folder(model_id)
      end

      def input_folder
        File.join INPUT_FOLDER, model_id.to_s
      end

      def log_folder(_ = nil)
        super model_id.to_s
      end

      def model_id
        @model_id
      end

      def model
        @model ||= ::Video.find model_id
      end
      alias init_model model

      def uploaded_file
        @uploaded_file
      end

    end
  end
end