class Video < MediaElement
  
  VIDEO_COMPONENT = 'video'
  TEXT_COMPONENT = 'text'
  IMAGE_COMPONENT = 'image'
  COMPONENTS = [VIDEO_COMPONENT, TEXT_COMPONENT, IMAGE_COMPONENT]
  
  def duration # FIXME temporaneo
    # metadata.duration
    YAML.load(File.open(Rails.root.join('db/seeds/videos/durations.yml'), 'r'))[(Video.where('id < ?', self.id).count % 5) + 1]
  end
  
  def mp4 # FIXME temporaneo
    # media.url.mp4
    "/media_elements/videos/#{self.id.to_s}/video_mp4.webm"
  end
  
  def webm # FIXME temporaneo
    # media.url.webm
    "/media_elements/videos/#{self.id.to_s}/video_webm.webm"
  end
  
  def thumb # FIXME temporaneo
    # media.thumb
    "/media_elements/videos/#{self.id.to_s}/thumb.jpg"
  end
  
  def cover # FIXME temporaneo
    # media.cover
    "/media_elements/videos/#{self.id.to_s}/cover.jpg"
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
  
end
