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
  
  def editing_path(user_id)
    "#{self.media.folder}/editing/user_#{user_id}"
  end
  
  def crop(x1, y1, x2, y2, user_id)
    return '' if x1.blank?
    ed_path = self.editing_path user_id
    if File.exists?(ed_path) && (Dir.entries(ed_path) - %w{ . .. }).any?
      img = MiniMagick::Image.open("#{ed_path}/#{Dir.entries(ed_path).sort.last}")
      width = img[:width]
      height = img[:height]
    else
      img = MiniMagick::Image.open(self.url)
      width = self.width
      height = self.height
      FileUtils.mkdir_p(ed_path) unless Dir.exists? ed_path
    end
    woh = Image.width_or_height(width, height)
    x1 = Image.ratio_value(woh[1], x1, woh[0])
    y1 = Image.ratio_value(woh[1], y1, woh[0])
    x2 = Image.ratio_value(woh[1], x2, woh[0])
    y2 = Image.ratio_value(woh[1], y2, woh[0])
    resp = Media::Image::Editing::Crop.new(img, editing_folder, x1, y1, x2, y2).run
    return "#{ed_path}/#{resp}"
  end
  
  def self.ratio_value(scale_to_px, value, original)
    if (original.to_i > scale_to_px.to_i )
      return value.to_f * (original.to_f / scale_to_px.to_f).to_f
    else
      return value
    end
  end
  
  def self.width_or_height(w, h)
    to_ratio = 660 / 495
    origin_ratio = w.to_f / h.to_f
    if origin_ratio > to_ratio
      return [w, 660]
    else
      return [h, 495]
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
