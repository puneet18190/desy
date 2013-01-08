require 'media'
require 'env_relative_path'

module Media
  class Uploader < String

    # require 'media/video/uploader/validation'

    include EnvRelativePath
    include AllowedDurationRange
    # include Validation

    attr_reader :model, :column, :value

    RAILS_PUBLIC = File.join Rails.root, 'public'
    cattr_accessor :public_relative_folder ,
                   :absolute_folder        ,
                   instance_reader: false, instance_writer: false
    cattr_accessor :extension_white_list          ,
                   :extension_white_list_with_dot ,
                   :min_duration                  ,
                   :duration_threshold            ,
                   :allowed_keys                  ,
                   :formats                       ,
                   :version_formats               ,
                   :conversion_class              ,
                   instance_writer: false
    # PUBLIC_RELATIVE_FOLDER        = env_relative_path 'media_elements/videos'
    # ABSOLUTE_FOLDER               = File.join RAILS_PUBLIC, PUBLIC_RELATIVE_FOLDER
    # EXTENSION_WHITE_LIST          = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)
    # EXTENSION_WHITE_LIST_WITH_DOT = EXTENSION_WHITE_LIST.map{ |ext| ".#{ext}" }
    # MIN_DURATION                  = 1
    # DURATION_THRESHOLD            = CONFIG.video.duration_threshold
    # ALLOWED_KEYS                  = [:filename] + FORMATS

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
        @converted_files                     = @value.select{ |k| formats.include? k }
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
      File.join self.class.absolute_folder, model_id.to_s
    end
    alias output_folder absolute_folder

    def public_relative_folder
      File.join '/', self.class.public_relative_folder, model_id.to_s
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
      _d format, formats
      File.join public_relative_folder, (
        case format
        when ->(f) { f.blank? }
          filename_without_extension
        when *formats
          filename(format)
        else
          ''
        end
      )
    end
    alias path public_relative_path

    def absolute_path(format)
      case format
      when *formats
        File.join absolute_folder, filename(format)
      when *version_formats.keys
        File.join absolute_folder, version_formats[format] % filename_without_extension
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

      extract_versions(infos)

      model.converted = true
      model.send :"rename_#{column}=", true
      model.send :"#{column}=", processed_original_filename_without_extension
      model[column] = processed_original_filename_without_extension
      model.save!

      model.send :"rename_#{column}=", nil
      model.skip_conversion = nil
      model.send :"reload_#{column}"
    end

    def extract_versions(infos)
    end

    def upload
      if not model.skip_conversion
        # FIXME a volte il file temporaneo caricato viene cancellato prima dell'inizio della conversione,
        #       per cui lo copio nella cartella temporanea delle conversioni. Bisognerebbe evitare questo passaggio
        #       e far sì che il file temporaneo non venga cancellato se possibile.
        #       Per non rallentare la risposta, si potrebbe far partire la copia in un thread e rinviare la conversione
        #       fin quando la copia non è finita
        raise 'model id cannot be blank' if model_id.blank?
        conversion_temp_path = conversion_class.temp_path(model_id, original_filename)
        conversion_temp_folder = File.dirname conversion_temp_path
        FileUtils.mkdir_p conversion_temp_folder
        FileUtils.cp @original_file.path, conversion_temp_path
        Delayed::Job.enqueue conversion_class::Job.new(@original_file.path, output_path_without_extension, original_filename, model_id)
      end
    end
  end
end
