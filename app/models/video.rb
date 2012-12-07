class Video < MediaElement
  
  VIDEO_COMPONENT = 'video'
  TEXT_COMPONENT  = 'text'
  IMAGE_COMPONENT = 'image'
  COMPONENTS = [VIDEO_COMPONENT, TEXT_COMPONENT, IMAGE_COMPONENT]

  after_save :upload
  after_destroy :clean

  attr_accessor :skip_conversion

  # TODO validazione media

  def self.test
    media_without_extension = Rails.root.join('spec/support/samples/con verted').to_s
    media = { copy: 'con verted', mp4: "#{media_without_extension}.mp4", webm: "#{media_without_extension}.webm" }
    video = new(title: 'title', description: 'description', tags: 'a,b,c,d,e', media: media) do |v|
      v.user_id = User.admin.id
    end
    # puts video.object_id.inspect
    video.save
    puts video[:media].class.inspect
    puts video.media.inspect
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
          return nil if p[:from] < 0 || p[:until] > video.duration || p[:from] >= p[:until]
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
    (hash.has_key?(key) && hash[key].kind_of?(Integer)) ? MediaElement.extract(hash[key], user_id, my_sti_type) : nil
  end

  def media
    @media || ( 
      media = read_attribute(:media)
      media ? VideoUploader.new(self, :media, media) : nil 
    )
  end

  def media=(media)
    @media = write_attribute :media, ( media.present? ? VideoUploader.new(self, :media, media) : nil )
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

  private
  def upload
    media.upload if media
  end

  def clean
    absolute_folder = media.try(:absolute_folder)
    FileUtils.rm_rf absolute_folder if absolute_folder and File.exists? absolute_folder
    true
  end
  
end
