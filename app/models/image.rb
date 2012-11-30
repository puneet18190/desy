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
  
  def ratio_value(scale_to_px,value)
    
    ratio = self.width.to_f / scale_to_px.to_f if (self.width.to_i > scale_to_px.to_i )
    
    if ratio
      return value.to_f * ratio.to_f
    else
      return value
    end
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
