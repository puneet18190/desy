# encoding: utf-8

require 'media_editing/video'
require 'media_editing/video/allowed_duration_range'

class VideoUploader < String

  require 'video_uploader/validation'

  include MediaEditing::Video::AllowedDurationRange
  include VideoUploader::Validation

  attr_reader :model, :column, :value

  # Paths are scoped in a folder named `Rails.env` unless the env is production
  # Example: log folder path
  #   Rails.env == development: 'log/video_editing/conversions/development'
  #   Rails.env == production:  'log/video_editing/conversions'
  def self.env_relative_path(path)
    Rails.env.production? ? path : File.join(path, Rails.env)
  end

  RAILS_PUBLIC                   = File.join Rails.root, 'public'
  PUBLIC_RELATIVE_FOLDER         = env_relative_path 'media_elements/videos'
  ABSOLUTE_FOLDER                = File.join RAILS_PUBLIC, PUBLIC_RELATIVE_FOLDER
  EXTENSIONS_WHITE_LIST          = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)
  EXTENSIONS_WHITE_LIST_WITH_DOT = EXTENSIONS_WHITE_LIST.map{ |ext| ".#{ext}" }
  MIN_DURATION                   = 1
  DURATION_THRESHOLD             = MediaEditing::Video::CONFIG.duration_threshold
  ALLOWED_KEYS                   = [:filename, :mp4, :webm]

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
      @converted_files                     = @value.select{ |k| [:mp4, :webm].include? k }
      @original_filename_without_extension = @value[:filename]
    else
      @filename_without_extension ||= ''
    end

  end

  def filename_without_extension
    @filename_without_extension || original_filename_without_extension
  end

  def process(string)
    string.parameterize
  end

  def processed_original_filename_without_extension
    process(original_filename_without_extension)
  end

  def original_filename_without_extension
    @original_filename_without_extension || File.basename(@original_filename, original_filename_extension)
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

  # converted
  #   true  : conversione andata a buon fine
  #   false : conversione non andata a buon fine
  #   nil   : conversione da effettuare o in fase di conversione

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
    File.join public_relative_folder, (format ? "#{filename_without_extension}.#{format}" : "#{filename_without_extension}")
  end
  alias path public_relative_path

  def absolute_path(format)
    return nil if model.new_record?
    File.join absolute_folder, "#{filename}.#{format}"
  end

  def public_relative_paths
    { mp4: path(:mp4), webm: path(:webm) }
  end
  alias paths public_relative_paths

  def mp4_path
    path(:mp4)
  end

  def webm_path
    path(:webm)
  end

  # def absolute_paths
  #   { mp4: absolute_path(:mp4), webm: absolute_path(:webm) }
  # end
  private
  def copy
    FileUtils.mkdir_p output_folder unless Dir.exists? output_folder
    
    @converted_files.each do |format, input_path|
      FileUtils.cp input_path, output_path(format)
      info = MediaEditing::Video::Info.new(input_path)
      model.send :"#{format}_duration=", info.duration
    end
    model.converted = true
    model.send :"rename_#{column}=", true
    model.send :"#{column}=", processed_original_filename_without_extension
    model[column] = processed_original_filename_without_extension
    model.save!

    model.send :"rename_#{column}=", nil
    model.skip_conversion = nil
    model.send :"reload_#{column}"
  end

  def upload
    if not model.skip_conversion
      Delayed::Job.enqueue MediaEditing::Video::Conversion::Job.new(model_id, @original_file.path, output_path_without_extension)
    end
  end

end
