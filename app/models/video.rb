require 'video_uploader'

# converted
#   true  : conversione andata a buon fine
#   false : conversione non andata a buon fine
#   nil   : conversione da effettuare o in fase di conversione
class Video < MediaElement
  
  COMPONENTS = %w(video text image)
  VIDEO_COMPONENT, TEXT_COMPONENT, IMAGE_COMPONENT = COMPONENTS

  after_save :upload_or_copy
  after_destroy :clean

  attr_accessor :skip_conversion, :rename_media

  validates_presence_of :media
  validate :media_validation
  
  # it doesn't check that the parameters are valid; it takes as input regardless the basic hash and the full one
  def self.total_prototype_time(hash)
    return 0 if !hash.has_key?(:components) || !hash[:components].kind_of?(Array)
    sum = 0
    hash[:components].each do |component|
      case component[:type]
        when VIDEO_COMPONENT
          return 0 if !component.has_key?(:until) || !component.has_key?(:from) || !component[:until].kind_of?(Integer) || !component[:from].kind_of?(Integer)
          sum += component[:until]
          sum -= component[:from]
        when IMAGE_COMPONENT
          return 0 if !component.has_key?(:duration) || !component[:duration].kind_of?(Integer)
          sum += component[:duration]
        when TEXT_COMPONENT
          return 0 if !component.has_key?(:duration) || !component[:duration].kind_of?(Integer)
          sum += component[:duration]
      else
        return 0
      end
    end
    sum
  end
  
  def self.convert_parameters(hash, user_id)
    return nil if !hash.kind_of?(Hash) || !hash.has_key?(:initial_video_id)
    return nil if !hash[:initial_video_id].nil? && !hash[:initial_video_id].kind_of?(Integer)
    return nil if !hash[:audio_id].nil? && !hash[:audio_id].kind_of?(Integer)
    resp_hash = {}
    if hash[:initial_video_id].nil?
      initial_video = nil
    else
      initial_video = Video.get_media_element_from_hash(hash, :initial_video_id, user_id, 'Video')
      return nil if initial_video.nil? || initial_video.is_public
    end
    resp_hash[:initial_video] = initial_video
    if hash[:audio_id].nil?
      audio_track = nil
    else
      audio_track = Video.get_media_element_from_hash(hash, :audio_id, user_id, 'Audio')
      return nil if audio_track.nil?
    end
    resp_hash[:audio] = audio_track
    return nil if !hash.has_key?(:components) || !hash[:components].kind_of?(Array)
    resp_hash[:components] = []
    hash[:components].each do |p|
      return nil if !p.kind_of?(Hash) || !p.has_key?(:type) || !COMPONENTS.include?(p[:type])
      case p[:type]
        when VIDEO_COMPONENT
          video = Video.get_media_element_from_hash(p, :video_id, user_id, 'Video')
          return nil if video.nil?
          return nil if !p.has_key?(:from) || !p[:from].kind_of?(Integer) || !p.has_key?(:until) || !p[:until].kind_of?(Integer)
          return nil if p[:from] < 0 || p[:until] > video.min_duration || p[:from] >= p[:until]
          resp_hash[:components] << {
            :type => VIDEO_COMPONENT,
            :video => video,
            :from => p[:from],
            :until => p[:until]
          }
        when TEXT_COMPONENT
          return nil if !p.has_key?(:content) || !p.has_key?(:duration) || !p.has_key?(:background_color) || !p.has_key?(:text_color)
          return nil if !p[:duration].kind_of?(Integer) || p[:duration] < 1 || !CONFIG['colors'].has_key?(p[:background_color]) || !CONFIG['colors'].has_key?(p[:text_color])
          resp_hash[:components] << {
            :type => TEXT_COMPONENT,
            :content => p[:content].to_s,
            :duration => p[:duration],
            :background_color => p[:background_color],
            :text_color => p[:text_color]
          }
        when IMAGE_COMPONENT
          image = Video.get_media_element_from_hash(p, :image_id, user_id, 'Image')
          return nil if image.nil?
          return nil if !p.has_key?(:duration) || !p[:duration].kind_of?(Integer) || p[:duration] < 1
          resp_hash[:components] << {
            :type => IMAGE_COMPONENT,
            :image => image,
            :duration => p[:duration]
          }
      end
    end
    resp_hash
  end
  
  def self.get_media_element_from_hash(hash, key, user_id, my_sti_type)
    hash.has_key?(key) && hash[key].kind_of?(Integer) ? MediaElement.extract(hash[key], user_id, my_sti_type) : nil
  end
  
  def min_duration
    d1 = self.mp4_duration.to_i
    d2 = self.webm_duration.to_i
    d1 > d2 ? d2 : d1
  end

  def mp4_path
    media.try(:path, :mp4)
  end

  def webm_path
    media.try(:path, :webm)
  end

  def cover_path
    media.try(:path, :cover)
  end
  
  def thumb_path
    media.try(:path, :thumb)
  end

  def media_validation
    media.validation if media
  end

  def media
    @media || ( 
      media = read_attribute(:media)
      media ? VideoUploader.new(self, :media, media) : nil 
    )
  end

  def media=(media)
    @media = write_attribute :media, (media.present? ? VideoUploader.new(self, :media, media) : nil)
  end

  def reload_media
    @media = nil
  end

  def mp4_duration
    metadata.mp4_duration
  end
  
  def webm_duration
    metadata.webm_duration
  end

  def mp4_duration=(mp4_duration)
    metadata.mp4_duration = mp4_duration
  end
  
  def webm_duration=(webm_duration)
    metadata.webm_duration = webm_duration
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
