require 'media'
require 'media/video'
require 'media/allowed_duration_range'
require 'env_relative_path'
require 'media/video/editing/cmd/extract_frame'
require 'media/video/editing/conversion'
require 'media/video/editing/conversion/job'
require 'media/image/editing/resize_to_fill'

module Media
  module Video
    class Uploader < String

      require 'media/video/uploader/validation'

      include EnvRelativePath
      include AllowedDurationRange
      include Validation

      attr_reader :model, :column, :value

      RAILS_PUBLIC                  = File.join Rails.root, 'public'
      PUBLIC_RELATIVE_FOLDER        = env_relative_path 'media_elements/videos'
      ABSOLUTE_FOLDER               = File.join RAILS_PUBLIC, PUBLIC_RELATIVE_FOLDER
      EXTENSION_WHITE_LIST          = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)
      EXTENSION_WHITE_LIST_WITH_DOT = EXTENSION_WHITE_LIST.map{ |ext| ".#{ext}" }
      MIN_DURATION                  = 1
      DURATION_THRESHOLD            = CONFIG.video.duration_threshold
      ALLOWED_KEYS                  = [:filename] + FORMATS

      def initialize(model, column, value)
        @model, @column, @value = model, column, value

        case @value
        when String
          @filename_without_extension = File.basename @value
        when File
          @original_file     = @value
          @original_filename = File.basename @value.path
          model.converted    = nil
        when ActionDispatch::Http::UploadedFile
          @original_file     = @value.tempfile
          @original_filename = @value.original_filename
          model.converted    = nil
        when Hash
          @converted_files                     = @value.select{ |k| FORMATS.include? k }
          @original_filename_without_extension = @value[:filename]
        else
          @filename_without_extension ||= ''
        end
      end

      def filename(format)
        "#{filename_without_extension}.#{format}"
      end

      def filename_without_extension
        (@filename_without_extension || original_filename_without_extension).to_s
      end

      def process(filename, extension = nil)
        if extension
          "#{filename.parameterize}.#{extension}"
        else
          filename.parameterize
        end
      end

      def processed_original_filename
        process(original_filename_without_extension, original_filename_extension)
      end

      def processed_original_filename_without_extension
        process(original_filename_without_extension)
      end

      def original_filename_without_extension
        @original_filename_without_extension || File.basename(original_filename, original_filename_extension)
      end

      def original_filename
        File.basename(@original_filename)
      end

      def original_filename_extension
        File.extname(@original_filename)
      end

      def blank?
        false
      end

      def upload_or_copy
        # TODO messaggio migliore
        raise 'unable to upload without a model id' unless model_id
        if @converted_files
          copy
        elsif @original_file
          upload
        end
        true
      end

      def output_path_without_extension
        File.join output_folder, processed_original_filename_without_extension
      end

      def output_path(format)
        "#{output_path_without_extension}.#{format}"
      end

      def absolute_folder
        File.join ABSOLUTE_FOLDER, model_id.to_s
      end
      alias output_folder absolute_folder

      def public_relative_folder
        File.join '/', PUBLIC_RELATIVE_FOLDER, model_id.to_s
      end

      def model_id
        model.id
      end

      def column_changed?
        model.send(:"#{column}_changed?")
      end

      def rename?
        model.send(:"rename_#{column}")
      end

      def to_s
        if column_changed? and rename?
          process(@value.to_s)
        else
          public_relative_path
        end
      end
      alias inspect to_s

      def public_relative_path(format = nil)
        case format
        when ->(f) { f.blank? }
          File.join public_relative_folder, filename_without_extension
        when *FORMATS
          File.join public_relative_folder, filename(format)
        when :cover, :thumb
          File.join public_relative_folder, VERSION_FORMATS[format] % filename_without_extension
        end
      end
      alias path public_relative_path

      def absolute_path(format)
        case format
        when *FORMATS
          File.join absolute_folder, filename(format)
        when :cover, :thumb
          File.join absolute_folder, VERSION_FORMATS[format] % filename_without_extension
        end
      end

      private
      def copy
        FileUtils.mkdir_p output_folder unless Dir.exists? output_folder
        
        infos = {}
        @converted_files.each do |format, input_path|
          FileUtils.cp input_path, output_path(format)
          info = Info.new(input_path)
          infos[format] = info
          model.send :"#{format}_duration=", info.duration
        end

        cover_path = File.join output_folder, COVER_FORMAT % processed_original_filename_without_extension
        extract_cover @converted_files[:mp4], cover_path, infos[:mp4].duration

        thumb_path = File.join output_folder, THUMB_FORMAT % processed_original_filename_without_extension
        extract_thumb cover_path, thumb_path, *THUMB_SIZES

        model.converted = true
        model.send :"rename_#{column}=", true
        model.send :"#{column}=", processed_original_filename_without_extension
        model[column] = processed_original_filename_without_extension
        model.save!

        model.send :"rename_#{column}=", nil
        model.skip_conversion = nil
        model.send :"reload_#{column}"
      end

      def extract_cover(input, output, duration)
        seek = duration / 2
        Editing::Cmd::ExtractFrame.new(input, output, seek).run!
        raise StandardError, 'unable to create cover' unless File.exists? output
      end

      def extract_thumb(input, output, width, height)
        Image::Editing::ResizeToFill.new(input, output, width, height).run
      end

      def upload
        if not model.skip_conversion
          # FIXME a volte il file temporaneo caricato viene cancellato prima dell'inizio della conversione,
          #       per cui lo copio nella cartella temporanea delle conversioni. Bisognerebbe evitare questo passaggio
          #       e far sì che il file temporaneo non venga cancellato se possibile.
          #       Per non rallentare la risposta, si potrebbe far partire la copia in un thread e rinviare la conversione
          #       fin quando la copia non è finita
          raise 'model id cannot be blank' if model_id.blank?
          conversion_temp_path = Editing::Conversion.temp_path(model_id, original_filename)
          conversion_temp_folder = File.dirname conversion_temp_path
          FileUtils.mkdir_p conversion_temp_folder
          FileUtils.cp @original_file.path, conversion_temp_path
          Delayed::Job.enqueue Media::Video::Editing::Conversion::Job.new(@original_file.path, output_path_without_extension, original_filename, model_id)
        end
      end
    end
  end
end
