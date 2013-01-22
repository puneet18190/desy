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
  
  def temporary_editing_image(user_id)
    ed_path = self.editing_path user_id
    return '' if !File.exists?(ed_path) || (Dir.entries(ed_path) - %w{ . .. }).empty?
    "#{ed_path}/#{Dir.entries(ed_path).sort.last}"
  end
  
  def process_textareas(params)
    ed_path = self.editing_path user_id
    img_path = self.temporary_editing_image(user_id)
    custom_filename = "tmp_#{Time.now.strftime('%Y%m%d-%H%M%S')}.jpg"
    if img_path.blank?
      FileUtils.mkdir_p(ed_path) unless Dir.exists? ed_path
      FileUtils.cp(self.media.path, "#{ed_path}/#{custom_filename}")
    else
      FileUtils.cp(img_path, "#{ed_path}/#{custom_filename}")
    end
    img_path = "#{ed_path}/#{custom_filename}"
    img = MiniMagick::Image.open(img_path)
    woh = Image.width_or_height(img[:width], img[:height])
    params.each do |p|
      color = p[:color]
      original_size = p[:font_size]
      font_size = Image.ratio_value woh[1], original_size, woh[0]
      coord_x = Image.ratio_value(woh[1], p[:coord_x], woh[0])
      coord_x = Image.ratio_value(woh[1], p[:coord_y], woh[0])
      tmp_file = Tempfile.new('textarea')
      begin
        tmp_file.write(p[:text])
        tmp_file.close
        cmd = Media::Image::Editing::AddTextToImage.new(img_path, color, font_size, coord_x, coord_y, tmp_file)
        puts cmd
        cmd.run!
      ensure
        tmp_file.unlink
      end
    end
    img_path
  end
  
  def crop(x1, y1, x2, y2, user_id)
    ed_path = self.editing_path user_id
    img_path = self.temporary_editing_image(user_id)
    if img_path.blank?
      FileUtils.mkdir_p(ed_path) unless Dir.exists? ed_path
      img = MiniMagick::Image.open(self.media.path)
      width = self.width
      height = self.height
    else
      img = MiniMagick::Image.open(img_path)
      width = img[:width]
      height = img[:height]
    end
    woh = Image.width_or_height(width, height)
    x1 = Image.ratio_value(woh[1], x1, woh[0])
    y1 = Image.ratio_value(woh[1], y1, woh[0])
    x2 = Image.ratio_value(woh[1], x2, woh[0])
    y2 = Image.ratio_value(woh[1], y2, woh[0])
    resp = Media::Image::Editing::Crop.new(img, ed_path, x1, y1, x2, y2).run
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
