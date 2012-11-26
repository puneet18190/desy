class Image < MediaElement
  mount_uploader :media, ImageUploader
  serialize :metadata, OpenStruct

  # TODO toglierlo da qui e metterlo in MediaElement una volta implementati tutti gli upload
  validates_presence_of :media

  before_save :set_width_and_height

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
