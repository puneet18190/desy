class Audio < MediaElement
  
  def mp3 # FIXME temporaneo
    # media.url.mp3
    "/media_elements/audio/#{self.id.to_s}/audio_mp3.mp3"
  end
  
  def ogg # FIXME temporaneo
    # media.url.ogg
    "/media_elements/audio/#{self.id.to_s}/audio_ogg.ogg"
  end
  
  def duration # FIXME temporaneo
    # metadata.duration
    YAML.load(File.open(Rails.root.join('db/seeds/audios/durations.yml'), 'r'))[1]
  end
  
end
