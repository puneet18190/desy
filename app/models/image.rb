class Image < MediaElement
  mount_uploader :media, ImageUploader

  # FIXME toglierlo da qui e metterlo in MediaElement una volta implementati tutti gli upload
  validates_presence_of :media
end
