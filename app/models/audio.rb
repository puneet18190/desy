class Audio < MediaElement
  
  def mp3_path # FIXME temporaneo
    # media.url.mp3
    "/media_elements/audios/#{self.id.to_s}/audio_mp3.mp3"
  end
  
  def ogg_path # FIXME temporaneo
    # media.url.ogg
    "/media_elements/audios/#{self.id.to_s}/audio_ogg.ogg"
  end
  
  def mp3_duration # FIXME temporaneo
    # metadata.duration
    YAML.load(File.open(Rails.root.join('db/seeds/audios/durations.yml'), 'r'))[1]
  end
  
  def ogg_duration # FIXME temporaneo
    # metadata.duration
    YAML.load(File.open(Rails.root.join('db/seeds/audios/durations.yml'), 'r'))[1]
  end
  
  def min_duration
    d1 = self.mp3_duration.to_i
    d2 = self.ogg_duration.to_i
    d1 > d2 ? d2 : d1
  end
  
end
