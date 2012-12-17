require 'media_editing'
require 'media/audio/editing'
require 'media_editing/logging'
require 'media_editing/allowed_duration_range'
require 'media_editing/info'
require 'media_editing/error'
require 'media/audio/editing/cmd/conversion'
require 'env_relative_path'

module MediaEditing
  module Audio
    class Conversion

      include EnvRelativePath
      include Logging
      include AllowedDurationRange

      TEMP_FOLDER        = Rails.root.join(env_relative_path('tmp/media/audio/editing/conversions')).to_s
      DURATION_THRESHOLD = CONFIG.audio.duration_threshold

      def self.log_folder
        super 'conversions'
      end

      attr_reader :model_id, :uploaded_path

      # Example: new('/tmp/path.abcdef', '/path/to/desy/public/media_elements/13/valid-audio', 'valid audio.mp3', 13)
      def initialize(uploaded_path, output_path_without_extension, original_filename, model_id)
        @model_id = model_id
        init_model

        @uploaded_path                 = uploaded_path
        @output_path_without_extension = output_path_without_extension
        @original_filename             = original_filename
      end

      def run
        begin
          mp3_conversion = Thread.new { convert_to(:mp3) }
          ogg_conversion = Thread.new { convert_to(:ogg) }

          mp3_conversion.abort_on_exception = ogg_conversion.abort_on_exception = true

          # Say to the parent thread (me) to wait the threads to finish before to continue
          mp3_conversion.join
          ogg_conversion.join

          mp3_file_info = Info.new output_path(:mp3)
          ogg_file_info = Info.new output_path(:ogg)

          unless allowed_duration_range?(mp3_file_info.duration, ogg_file_info.duration) 
            raise Error.new( 'output audios have different duration', 
                             model_id: model_id, mp3_duration: mp3_file_info.duration, ogg_duration: ogg_file_info.duration )
          end

        rescue StandardError => e
          model.update_column(:converted, false) if model.present?
          FileUtils.rm_rf output_folder if Dir.exists? output_folder
          raise e
        end

        model.converted    = true
        model.rename_media = true
        model.mp3_duration = mp3_file_info.duration
        model.ogg_duration = ogg_file_info.duration
        model.media        = output_filename_without_extension
        model[:media]      = output_filename_without_extension
        model.save!

        FileUtils.rm temp_path
      end

      def convert_to(format)
        if not File.exists? uploaded_path and not File.exists? temp_path
          raise Error.new( "at least one between uploaded_path and temp_path must exist", 
                           temp_path: temp_path, uploaded_path: uploaded_path, format: format )
        end

        FileUtils.mkdir_p temp_folder unless Dir.exists? temp_folder

        # If temp_path already exists, I assume that someone has already processed it before;
        # so I use it (I use it as cache)
        FileUtils.mv uploaded_path, temp_path unless File.exists? temp_path

        FileUtils.mkdir_p output_folder unless Dir.exists? output_folder
        
        begin
          output_path = output_path(format)

          log_folder = create_log_folder
          stdout_log, stderr_log = stdout_log(format), stderr_log(format)

          Cmd::Conversion.new(temp_path, output_path, format).run! %W(#{stdout_log} a), %W(#{stderr_log} a)
        rescue StandardError => e
          FileUtils.rm_rf output_folder if Dir.exists? output_folder
          raise e
        end

      end

      private

      def output_path(format)
        "#{@output_path_without_extension}.#{format}"
      end

      def uploaded_path_extension
        File.extname @uploaded_path
      end

      def output_filename_without_extension
        File.basename @output_path_without_extension
      end

      def output_folder
        File.dirname @output_path_without_extension
      end

      def temp_path
        File.join temp_folder, @original_filename
      end

      def temp_folder
        File.join TEMP_FOLDER, model_id.to_s
      end

      def log_folder(_ = nil)
        super model_id.to_s
      end

      def model
        @model ||= ::Audio.find model_id
      end
      alias init_model model

    end
  end
end