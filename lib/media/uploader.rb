require 'media'
require 'media/similar_durations'
require 'securerandom'
require 'find'

module Media
  class Uploader < String
    include SimilarDurations

    attr_reader :model, :column, :value
    # cattr_accessor :media_elements_folder_size

    PUBLIC_RELATIVE_MEDIA_ELEMENTS_FOLDER = 'media_elements'
    MEDIA_ELEMENTS_FOLDER                 = RAILS_PUBLIC_FOLDER.join PUBLIC_RELATIVE_MEDIA_ELEMENTS_FOLDER
    MAXIMUM_MEDIA_ELEMENTS_FOLDER_SIZE    = SETTINGS['maximum_media_elements_folder_size'].gigabytes.to_i

    def self.remove_folder!
      FileUtils.rm_rf self::FOLDER
    end

    def self.media_elements_folder_size
      Find.find(MEDIA_ELEMENTS_FOLDER).sum { |f| File.stat(f).size }
    end

    def self.maximum_media_elements_folder_size_exceeded?
      media_elements_folder_size > MAXIMUM_MEDIA_ELEMENTS_FOLDER_SIZE
    end

    def initialize(model, column, value)
      @model, @column, @value = model, column, value

      case @value
      when String
        @filename_without_extension = File.basename @value
      when File
        @original_file     = @value
        @original_filename = File.basename @value.path
        model.converted    = false
      when ActionDispatch::Http::UploadedFile
        @original_file     = @value.tempfile
        @original_filename = @value.original_filename
        model.converted    = false
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
      filename = "#{filename.parameterize}_#{model.filename_token}"
      filename << ".#{extension}" if extension
      filename
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
      raise Error.new('model_id cannot be blank', model: @model, column: @column, value: @value) if model_id.blank?

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

    def paths
      Hash[ (self.class::FORMATS + self.class::VERSION_FORMATS.keys).map{ |f| [f, path(f)] } ]
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

      true
    end

    def extract_versions(infos)
    end

    def upload_copy_and_job(conversion_temp_path)
      FileUtils.cp @original_file.path, conversion_temp_path
      Delayed::Job.enqueue self.class::CONVERSION_CLASS::Job.new(@original_file.path, output_path_without_extension, original_filename, model_id)
    end

    def upload
      return if model.skip_conversion

      conversion_temp_path = self.class::CONVERSION_CLASS.temp_path(model_id, original_filename)

      FileUtils.mkdir_p File.dirname(conversion_temp_path)

      # FIXME Test environment doesn't use delayed_job, so parallel execution breaks tests
      Rails.env.test? ? upload_copy_and_job(conversion_temp_path) : EnhancedThread.new{ upload_copy_and_job(conversion_temp_path) }
    end
  end
end
