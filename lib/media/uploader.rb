require 'media'

module Media
  class Uploader < String

    include AllowedDurationRange

    attr_reader :model, :column, :value

    RAILS_PUBLIC = File.join Rails.root, 'public'

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
        @converted_files                     = @value.select{ |k| self.class::FORMATS.include? k }
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

    def folder
      File.join self.class::FOLDER, model_id.to_s
    end
    alias output_folder folder

    def public_relative_folder
      File.join '/', self.class::PUBLIC_RELATIVE_FOLDER, model_id.to_s
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
      File.join public_relative_folder, (
        case format
        when ->(f) { f.blank? }
          filename_without_extension
        when *self.class::FORMATS
          filename(format)
        when *self.class::VERSION_FORMATS.keys
          self.class::VERSION_FORMATS[format] % filename_without_extension
        else
          ''
        end
      )
    end
    alias url public_relative_path

    def path(format)
      case format
      when *self.class::FORMATS
        File.join folder, filename(format)
      when *self.class::VERSION_FORMATS.keys
        File.join folder, self.class::VERSION_FORMATS[format] % filename_without_extension
      end
    end

    def to_hash
      Hash[ self.class::FORMATS.map{ |f| [f, path(f)] } ].merge(filename: filename_without_extension)
    end

    private
    def copy
      FileUtils.mkdir_p output_folder unless Dir.exists? output_folder
      
      infos = {}
      @converted_files.each do |format, input_path|
        output_path = output_path(format)
        # se il percorso del file è uguale a quello vecchio è lo stesso file; per cui non copio
        # (è un caso che si verifica p.e. nel caso di un errore nel Composer, che ripristina il file vecchio)
        FileUtils.cp input_path, output_path if input_path != output_path
        info = Info.new(output_path)
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
        conversion_temp_path = self.class::CONVERSION_CLASS.temp_path(model_id, original_filename)
        conversion_temp_folder = File.dirname conversion_temp_path
        FileUtils.mkdir_p conversion_temp_folder
        FileUtils.cp @original_file.path, conversion_temp_path
        Delayed::Job.enqueue self.class::CONVERSION_CLASS::Job.new(@original_file.path, output_path_without_extension, original_filename, model_id)
      end
    end
  end
end
