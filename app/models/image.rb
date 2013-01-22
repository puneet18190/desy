class Image < MediaElement
  EXTENSION_WHITE_LIST = ImageUploader::EXTENSION_WHITE_LIST
  
  mount_uploader :media, ImageUploader
  
  before_save :set_width_and_height
  
  attr_reader :edit_mode
  
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
  
  def editing_url
    return '' if !self.in_edit_mode?
    my_url = self.url
    file_name = my_url.split('/').last
    "#{my_url.gsub(file_name, '')}/editing/user_#{user_id}/tmp.#{self.media.file.extension}"
  end
  
  def prev_editing_image
    return '' if !self.in_edit_mode?
    "#{self.media.folder}/editing/user_#{@edit_mode}/prev.#{self.media.file.extension}"
  end
  
  def current_editing_image
    return '' if !self.in_edit_mode?
    "#{self.media.folder}/editing/user_#{@edit_mode}/tmp.#{self.media.file.extension}"
  end
  
  def in_edit_mode?
    !@edit_mode.nil?
  end
  
  def enter_edit_mode(user_id)
    @edit_mode = user_id
    ed_path = "#{self.media.folder}/editing/user_#{@edit_mode}"
    FileUtils.mkdir_p(ed_path) if !Dir.exists?(ed_path)
    curr_path = current_editing_image
    FileUtils.cp(self.media.path, curr_path) if !File.exists?(curr_path)
    true
  end
  
  def leave_edit_mode
    return false if !self.in_edit_mode?
    ed_path = "#{self.media.folder}/editing/user_#{@edit_mode}"
    FileUtils.rm_r(ed_path) if Dir.exists?(ed_path)
    @edit_mode = nil
    true
  end
  
  def save_editing_prev
    return false if !self.in_edit_mode?
    prev_path = self.prev_editing_image
    curr_path = self.current_editing_image
    begin
      FileUtils.rm(prev_path) if File.exists?(prev_path)
      FileUtils.cp(curr_path, prev_path)
      FileUtils.rm(curr_path)
    rescue
      return false
    end
    true
  end
  
  def add_text(color, font_size, coord_x, coord_y, text)
    return false if !self.in_edit_mode? || !self.save_editing_prev
    img = MiniMagick::Image.open self.current_editing_image
    font_size = Image.ratio_value img[:width], img[:height], font_size
    coord_x = Image.ratio_value img[:width], img[:height], coord_x
    coord_x = Image.ratio_value img[:width], img[:height], coord_y
    tmp_file = Tempfile.new('textarea')
    begin
      tmp_file.write(text)
      tmp_file.close
      Media::Image::Editing::AddTextToImage.new(self.current_editing_image, color, font_size, coord_x, coord_y, tmp_file).run!
    ensure
      tmp_file.unlink
    end
    true
  end
  
  def crop(x1, y1, x2, y2, user_id)
    return false if !self.in_edit_mode?
    
    
    
    img_path = self.temporary_editing_image

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
    resp = Media::Image::Editing::Crop.new(img_path, img, ed_path, x1, y1, x2, y2).run
    return "#{ed_url}/#{resp}"
  end
  
  def self.ratio_value(w, h, value)
    to_ratio = 660 / 495
    origin_ratio = w.to_f / h.to_f
    if origin_ratio > to_ratio
      h = w
      w = 660
    else
      w = 495
    end
    if (h.to_i > w.to_i )
      return value.to_f * (h.to_f / w.to_f)
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
