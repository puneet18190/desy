class Video < MediaElement
  
  VIDEO_COMPONENT = 'video'
  TEXT_COMPONENT = 'text'
  IMAGE_COMPONENT = 'image'
  COMPONENTS = [VIDEO_COMPONENT, TEXT_COMPONENT, IMAGE_COMPONENT]
  
  COLORS = {
    :red => 'B51726', # colore sfondo della componente 'testo' nella timeline nel psd dell'editor video
    :green => '#41A62A', # colore elementi didattici
    :light_green => '#95E195', # scelto da me
    :orange => '#F29400', # colore lezioni
    :blue => '#2807CE', # scelto da me
    :light_blue => '#2EAADC', # colore virtual classroom
    :white => '#F2F2F2', # scelto da me
    :black => '#373737', # colore dell'header desy
    :gray => '#7D7D7D', # scritta 'profile' nel menu quando è selezionata (non sfondo)
    :purple => '#6A05AE', # scelto da me
    :yellow => '#FDB525', # sfondo sezione 'what is DESY'
    :brown => '#622F0B', # scelto da me
    :pink => '#F4D0F3' # scelto da me
  }
  
  def duration # FIXME temporaneo
    # metadata.duration
    YAML.load(File.open(Rails.root.join('db/seeds/videos/durations.yml'), 'r'))[(Video.where('id < ?', self.id).count % 5) + 1]
  end
  
  def mp4 # FIXME temporaneo
    # media.url.mp4
    Rails.root.join "db/seeds/videos/url/mp4/#{(Video.where('id < ?', self.id).count % 5) + 1}.webm"
  end
  
  def webm # FIXME temporaneo
    # media.url.webm
    Rails.root.join "db/seeds/videos/url/webm/#{(Video.where('id < ?', self.id).count % 5) + 1}.webm"
  end
  
  def thumb # FIXME temporaneo
    # media.thumb
    Rails.root.join "db/seeds/videos/thumb/#{(Video.where('id < ?', self.id).count % 5) + 1}.jpg"
  end
  
  def cover # FIXME temporaneo
    # media.cover
    Rails.root.join "db/seeds/videos/cover/#{(Video.where('id < ?', self.id).count % 5) + 1}.jpg"
  end
  
  def self.convert(hash, user_id)
    return nil if !hash.kind_of?(Hash)
    resp_hash = {}
    initial_video = Video.get_media_element_from_hash(hash, :initial_video_id, user_id, 'Video')
    return nil if initial_video.nil?
    resp_hash[:initial_video] = initial_video
    audio_track = Video.get_media_element_from_hash(hash, :audio_id, user_id, 'Audio')
    return nil if audio_track.nil?
    resp_hash[:audio] = audio_track
    return nil if !hash.has_key?(:parameters) || !hash[:parameters].kind_of?(Array)
    resp_hash[:parameters] = []
    hash[:parameters].each do |p|
      return nil if !p.kind_of?(Hash) || !p.has_key?(:component)
      case p[:component]
        when VIDEO_COMPONENT
          video = Video.get_media_element_from_hash(p, :video_id, user_id, 'Video')
          return nil if video.nil?
          return nil if !p.has_key?(:from) || !p[:from].kind_of?(Integer) || !p.has_key?(:until) || !p[:until].kind_of?(Integer)
          return nil if p[:from] < 0 || p[:until] > video.duration
        when TEXT_COMPONENT
          
        when IMAGE_COMPONENT
          
      end
    end
  end
  
  def self.get_media_element_from_hash(hash, key, user_id, my_sti_type)
    (hash.has_key?(key) && hash[key].kind_of?(Integer)) ? MediaElement.extract(hash[key], user_id, my_sti_type) : nil
  end
  
  
#  {
#    :initial_video_id => 6,
#    :audio_id => nil,
#    :parameters => [
#      {
#        :component => Video::VIDEO_COMPONENT,
#        :video_id => 1,
#        :from => 12,
#        :until => 24
#      },
#      {
#        :component => Video::TEXT_COMPONENT,
#        :content => 'Titolo titolo titolo',
#        :duration => 14,
#        :background_color => :red,
#        :text_color => :white
#      },
#      {
#        :component => Video::IMAGE_COMPONENT,
#        :image_id => 3,
#        :duration => 2
#      }
#    ]
#  }
  
end
