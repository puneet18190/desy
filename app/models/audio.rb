#require 'audio_uploader'

class Audio < MediaElement

  after_save :upload_or_copy
  after_destroy :clean

  attr_accessor :skip_conversion, :rename_media

  validates_presence_of :media
  validate :media_validation
  
  def mp3_path
    media.try(:path, :mp3)
  end

  def ogg_path
    media.try(:path, :ogg)
  end
  
  def mp3_duration
    metadata.mp3_duration
  end
  
  def ogg_duration
    metadata.ogg_duration
  end

  def mp3_duration=(mp3_duration)
    metadata.mp3_duration = mp3_duration
  end
  
  def ogg_duration=(ogg_duration)
    metadata.ogg_duration = ogg_duration
  end
  
  def min_duration
    [mp3_duration, ogg_duration].map(&:to_i).min
  end
  
  def media
    @media || ( 
      media = read_attribute(:media)
      media ? AudioUploader.new(self, :media, media) : nil 
    )
  end

  def media=(media)
    @media = write_attribute :media, (media.present? ? AudioUploader.new(self, :media, media) : nil)
  end

  def reload
    @media = @skip_conversion = @rename_media = nil
    super
  end

  private
  def upload_or_copy
    media.upload_or_copy if media
    true
  end

  def clean
    absolute_folder = media.try(:absolute_folder)
    FileUtils.rm_rf absolute_folder if absolute_folder and File.exists? absolute_folder
    true
  end
end
