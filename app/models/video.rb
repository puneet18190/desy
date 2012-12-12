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
  
  # EXAMPLE OF RETURNED HASH:
  # - two initial parameters, 'initial_video' and 'audio_track'
  # - then an ordered array of components:
  #   - each component is a hash, with a key called :type
  #   - if the type is 'video', there is an object of kind VIDEO associated to the key :video
  #   - if the type is 'image', there is an object of kind IMAGE associated to the key :image
  #
  #  {
  #    :initial_video => OBJECT OF TYPE VIDEO or NIL,
  #    :audio_track => OBJECT OF TYPE AUDIO or NIL,
  #    :components => [
  #      {
  #        :type => Video::VIDEO_COMPONENT,
  #        :video => OBJECT OF TYPE VIDEO,
  #        :from => 12,
  #        :until => 24
  #      },
  #      {
  #        :type => Video::TEXT_COMPONENT,
  #        :content => 'Titolo titolo titolo',
  #        :duration => 14,
  #        :background_color => 'red',
  #        :text_color => 'white'
  #      },
  #      {
  #        :type => Video::IMAGE_COMPONENT,
  #        :image => OBJECT OF TYPE IMAGE,
  #        :duration => 2
  #      }
  #    ]
  #  }
  def self.convert_parameters(hash, user_id)
    
    # check if initial video and audio track are correctly declared (they can be nil or integer)
    return nil if !hash.kind_of?(Hash) || !hash.has_key?(:initial_video_id)
    return nil if !hash[:initial_video_id].nil? && !hash[:initial_video_id].kind_of?(Integer)
    return nil if !hash[:audio_id].nil? && !hash[:audio_id].kind_of?(Integer)
    
    # initialize empty hash
    resp_hash = {}
    
    # if initial video is present, I validate that it exists and is accessible from the user
    if hash[:initial_video_id].nil?
      initial_video = nil
    else
      initial_video = Video.get_media_element_from_hash(hash, :initial_video_id, user_id, 'Video')
      return nil if initial_video.nil? || initial_video.is_public
    end
    
    # insert initial video (which is nil if the video does not overwrite any previous one)
    resp_hash[:initial_video] = initial_video
    
    # if audio track is present, I validate that it exists and is accessible from the user
    if hash[:audio_id].nil?
      audio_track = nil
    else
      audio_track = Video.get_media_element_from_hash(hash, :audio_id, user_id, 'Audio')
      return nil if audio_track.nil?
    end
    
    # insert audio track (which is nil if the user wants to keep the original audio of each component)
    resp_hash[:audio] = audio_track
    
    # there must be a list of components
    return nil if !hash.has_key?(:components) || !hash[:components].kind_of?(Array)
    
    # initialize empty components
    resp_hash[:components] = []
    
    # for each component I validate it and add it to the HASH
    hash[:components].each do |p|
      return nil if !p.kind_of?(Hash) || !p.has_key?(:type) || !COMPONENTS.include?(p[:type])
      case p[:type]
        when VIDEO_COMPONENT
          c = Video.extract_video_component(p, user_id)
          return nil if c.nil?
          resp_hash[:components] << c
        when TEXT_COMPONENT
          c = Video.extract_text_component(p)
          return nil if c.nil?
          resp_hash[:components] << c
        when IMAGE_COMPONENT
          c = Video.extract_image_component(p, user_id)
          return nil if c.nil?
          resp_hash[:components] << c
      end
    end
    
    resp_hash
  end
  
  def self.extract_image_component(component, user_id)
    image = Video.get_media_element_from_hash(component, :image_id, user_id, 'Image')
    # I validate that the image exists and is accessible from the user
    return nil if image.nil?
    # DURATION is correct
    return nil if !component.has_key?(:duration) || !component[:duration].kind_of?(Integer) || component[:duration] < 1
    {
      :type => IMAGE_COMPONENT,
      :image => image,
      :duration => component[:duration]
    }
  end
  
  def self.extract_video_component(component, user_id)
    video = Video.get_media_element_from_hash(component, :video_id, user_id, 'Video')
    # I validate that the video exists and is accessible from the user
    return nil if video.nil?
    # FROM and UNTIL are correct
    return nil if !component.has_key?(:from) || !component[:from].kind_of?(Integer) || !component.has_key?(:until) || !component[:until].kind_of?(Integer)
    return nil if component[:from] < 0 || component[:until] > video.min_duration || component[:from] >= component[:until]
    {
      :type => VIDEO_COMPONENT,
      :video => video,
      :from => component[:from],
      :until => component[:until]
    }
  end
  
  def self.extract_text_component(component)
    # CONTENT, COLORS, and DURATION are present and correct
    return nil if !component.has_key?(:content) || !component.has_key?(:duration) || !component.has_key?(:background_color) || !component.has_key?(:text_color)
    return nil if !component[:duration].kind_of?(Integer) || component[:duration] < 1
    return nil if !CONFIG['colors'].has_key?(component[:background_color]) || !CONFIG['colors'].has_key?(component[:text_color])
    {
      :type => TEXT_COMPONENT,
      :content => component[:content].to_s,
      :duration => component[:duration],
      :background_color => component[:background_color],
      :text_color => component[:text_color]
    }
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
