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
    10
  end
  
  def mp4 # FIXME temporaneo
    # media.url.mp4
    Rails.root.join "db/seeds/video/#{(Video.where('id < ?', self.id).count % 5) + 1}.webm"
  end
  
  def webm # FIXME temporaneo
    # media.url.webm
    Rails.root.join "db/seeds/video/#{(Video.where('id < ?', self.id).count % 5) + 1}.webm"
  end
  
  def thumb # FIXME temporaneo
    # media.thumb
    Image.first.media.thumb
  end
  
end
