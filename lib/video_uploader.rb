# encoding: utf-8

class VideoUploader < String

  attr_reader :model, :column, :tempfile, :original_filename, :raw

  # Paths are scoped in a folder named `Rails.env` unless the env is production
  # Example: log folder path
  #   Rails.env == development: 'log/video_editing/conversions/development'
  #   Rails.env == production:  'log/video_editing/conversions'
  def self.env_relative_path(path)
    Rails.env.production? ? path : File.join(path, Rails.env)
  end

  RAILS_PUBLIC          = File.join Rails.root, 'public'
  RELATIVE_FOLDER       = env_relative_path 'media_elements/videos'
  FOLDER                = File.join RAILS_PUBLIC, RELATIVE_FOLDER
  EXTENSIONS_WHITE_LIST = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)

  def self.folder(model_id)
    File.join FOLDER, model_id.to_s
  end

  def initialize(model, column, raw)
    @model, @column, @raw = model, column, raw

    if @raw.is_a? ActionDispatch::Http::UploadedFile
      @original_filename = @raw.original_filename
      @tempfile          = @raw.tempfile
      @model.converted   = nil
    end
  end

  def absolute_folder
    self.class.folder(model_id.to_s)
  end

  def relative_folder
    File.join RELATIVE_FOLDER, model_id.to_s
  end

  def model_id
    model.try(:id)
  end

  def to_s
    raw.to_s
  end

  def path(format)
    "#{relative_folder}/#{raw}.#{format}"
  end

  def inspect
    to_s
  end

end
