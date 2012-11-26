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
  def set_width_and_height
    metadata.width  = media.width
    metadata.height = media.height
    true 
  end

end
