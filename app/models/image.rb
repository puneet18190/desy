class Image < MediaElement
  
  mount_uploader :media, ImageUploader
  serialize :metadata, OpenStruct
  
  # TODO toglierlo da qui e metterlo in MediaElement una volta implementati tutti gli upload
  validates_presence_of :media
  
  before_save :set_width_and_height
  
  def url
    media.url
  end
  
  def thumb
    media.thumb
  end
  
  def width
    metadata.width
  end
  
  def height
    metadata.height
  end
  
  def ratio_value(scale_to_px,value,w_or_h)
    if w_or_h == "w"
      ratio = medatata.width / scale_to_px
    else
      ratio = medatata.height / scale_to_px
    end
    return value * ratio
  end
  
  private
  
  def width=(width)
    metadata.width = width
  end
  
  def height=(height)
    metadata.height = height
  end
  
  def set_width_and_height
    self.width, self.height = media.width, media.height
    true
  end
  
end
