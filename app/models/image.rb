class Image < MediaElement
  EXTENSION_WHITE_LIST = ImageUploader::EXTENSION_WHITE_LIST
  
  mount_uploader :media, ImageUploader
  
  before_save :set_width_and_height
  
  def url
    media.url
  end
  
  def thumb_url
    media.thumb.url
  end
  
  def width
    metadata.width
  end
  
  def height
    metadata.height
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
