# encoding: utf-8

class VideoUploader < String

  attr_reader :model, :column, :tempfile, :original_filename, :value

  # Paths are scoped in a folder named `Rails.env` unless the env is production
  # Example: log folder path
  #   Rails.env == development: 'log/video_editing/conversions/development'
  #   Rails.env == production:  'log/video_editing/conversions'
  def self.env_relative_path(path)
    Rails.env.production? ? path : File.join(path, Rails.env)
  end

  RAILS_PUBLIC           = File.join Rails.root, 'public'
  PUBLIC_RELATIVE_FOLDER = env_relative_path 'media_elements/videos'
  FOLDER                 = File.join RAILS_PUBLIC, PUBLIC_RELATIVE_FOLDER
  EXTENSIONS_WHITE_LIST  = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)

  def self.folder(model_id)
    File.join FOLDER, model_id.to_s
  end

  def initialize(model, column, value)
    @model, @column, @value = model, column, value

    case @value
    when ActionDispatch::Http::UploadedFile
      @original_filename = @value.original_filename
      @tempfile          = @value.tempfile
      @model.converted   = nil
    when Hash
      if value.keys.sort == [:copy, :mp4, :webm] and value[:copy]
        @original_filename = value[:copy]
        model.converted = true
        @copy = true
      else
        # TODO fare una cosa più 'ngarbata'
        raise "keys should be [:copy, :mp4, :webm], instead of #{value.keys.sort.inspect}"
      end
    end
  end

  # converted
  #   true  : conversione andata a buon fine
  #   false : conversione non andata a buon fine
  #   nil   : conversione da effettuare o in fase di conversione
  def upload
    if @copy
      value.select{ |k| [:mp4, :webm].include? k }.each do |format, input_path|
        FileUtils.mkdir_p output_folder unless Dir.exists? output_folder
        FileUtils.cp input_path, output_path(format)
      end
      @value = output_filename_without_extension
      model.update_attribute column, output_filename_without_extension
    elsif not skip_conversion and converted.nil?
      Delayed::Job.enqueue MediaEditing::Video::Conversion::Job.new(model_id, output_path_without_extension, tempfile.path)
    end
    true
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

  def output_path_without_extension
    File.join output_folder, output_filename_without_extension
  end

  def output_path(format)
    "#{output_path_without_extension}.#{format}"
  end

  def absolute_folder
    self.class.folder(model_id.to_s)
  end
  alias output_folder absolute_folder

  def public_relative_folder
    File.join '/', PUBLIC_RELATIVE_FOLDER, model_id.to_s
  end

  def model_id
    model.id
  end

  def skip_conversion
    model.skip_conversion
  end

  def converted
    model.converted
  end

  def to_s
    model.new_record? ? value.to_s : public_relative_path
  end
  alias inspect to_s

  def public_relative_path(format = nil)
    File.join public_relative_folder, (format ? "#{value}.#{format}" : value)
  end
  alias path public_relative_path

  def absolute_path(format = nil)
    File.join absolute_folder, (format ? "#{value}.#{format}" : value)
  end

  def public_relative_paths
    { mp4: path(:mp4), webm: path(:webm) }
  end
  alias paths public_relative_paths

  def absolute_paths
    { mp4: absolute_path(:mp4), webm: absolute_path(:webm) }
  end

end
