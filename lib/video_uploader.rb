# encoding: utf-8

require 'media_editing/video/allowed_duration_range'
require 'env_relative_path'
require 'media_editing/video/cmd/extract_frame'

class VideoUploader < String

  require 'video_uploader/validation'

  include EnvRelativePath
  include MediaEditing::Video::AllowedDurationRange
  include VideoUploader::Validation


  attr_reader :model, :column, :value

  FORMATS                        = [:mp4, :webm]
  RAILS_PUBLIC                   = File.join Rails.root, 'public'
  PUBLIC_RELATIVE_FOLDER         = env_relative_path 'media_elements/videos'
  ABSOLUTE_FOLDER                = File.join RAILS_PUBLIC, PUBLIC_RELATIVE_FOLDER
  EXTENSIONS_WHITE_LIST          = %w(avi divx flv h264 mkv mov mp4 mpe mpeg mpg ogm ogv webm wmv xvid)
  EXTENSIONS_WHITE_LIST_WITH_DOT = EXTENSIONS_WHITE_LIST.map{ |ext| ".#{ext}" }
  MIN_DURATION                   = 1
  DURATION_THRESHOLD             = MediaEditing::Video::CONFIG.duration_threshold
  ALLOWED_KEYS                   = [:filename] + FORMATS
  VERSION_FORMATS                = { cover: 'cover_%s.jpg', thumb: 'thumb_%s.jpg' }
  COVER_FORMAT, THUMB_FORMAT     = VERSION_FORMATS[:cover], VERSION_FORMATS[:thumb]
  THUMB_SIZES                    = [200, 200]

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
      File.join public_relative_folder, filename_without_extension.to_s
    when *FORMATS
      File.join public_relative_folder, "#{filename_without_extension}.#{format}"
    when :cover, :thumb
      File.join public_relative_folder, VERSION_FORMATS[format] % filename_without_extension.to_s
    end
  end
  alias path public_relative_path

  def public_relative_paths
    { mp4: path(:mp4), webm: path(:webm) }
  end
  alias paths public_relative_paths

  def absolute_path(format)
    case format
    when *FORMATS
      File.join absolute_folder, "#{filename_without_extension}.#{format}"
    when :cover, :thumb
      File.join absolute_folder, VERSION_FORMATS[format] % filename_without_extension.to_s
    end
  end

  def absolute_paths
    Hash[ [:mp4, :webm, :cover, :thumb].map{ |v| [v, absolute_path(v)] } ]
  end

  private
  def copy
    FileUtils.mkdir_p output_folder unless Dir.exists? output_folder
    
    infos = {}
    @converted_files.each do |format, input_path|
      FileUtils.cp input_path, output_path(format)
      info = MediaEditing::Video::Info.new(input_path)
      infos[format] = info
      model.send :"#{format}_duration=", info.duration
    end

    cover_path = File.join output_folder, COVER_FORMAT % processed_original_filename_without_extension
    extract_cover @converted_files[:mp4], cover_path, infos[:mp4].duration / 2

    # TODO ho copiato il resize to fill da carrierwave, adattarlo
    thumb_path = File.join output_folder, THUMB_FORMAT % processed_original_filename_without_extension
    # thumb_path = THUMB_FORMAT % output_path_without_extension
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

  def extract_cover(input, output, seek)
    MediaEditing::Video::Cmd::ExtractFrame.new(input, output, seek).run!
    raise StandardError, 'unable to create cover' unless File.exists? output
  end

  def upload
    if not model.skip_conversion
      Delayed::Job.enqueue MediaEditing::Video::Conversion::Job.new(model_id, @original_file.path, output_path_without_extension)
    end
  end

  def extract_thumb(input, output, width, height)
    input_image = ::MiniMagick::Image.open(input)
    cols, rows = input_image[:dimensions]
    input_image.combine_options do |cmd|
      if width != cols || height != rows
        scale_x = width/cols.to_f
        scale_y = height/rows.to_f
        if scale_x >= scale_y
          cols = (scale_x * (cols + 0.5)).round
          rows = (scale_x * (rows + 0.5)).round
          cmd.resize "#{cols}"
        else
          cols = (scale_y * (cols + 0.5)).round
          rows = (scale_y * (rows + 0.5)).round
          cmd.resize "x#{rows}"
        end
      end
      cmd.gravity 'Center'
      cmd.background "rgba(255,255,255,0.0)"
      cmd.extent "#{width}x#{height}" if cols != width || rows != height
    end
    input_image.write(output)
  end

end
