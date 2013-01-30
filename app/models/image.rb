require 'shellwords'
require 'media/image/editing/add_text_to_image'
require 'media/image/editing/crop'

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
    file_name = "/#{my_url.split('/').last}"
    "#{my_url.gsub(file_name, '')}/editing/user_#{@edit_mode}/tmp.#{self.media.file.extension}"
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
    ed_dir = "#{self.media.folder}/editing/user_#{@edit_mode}"
    FileUtils.mkdir_p(ed_dir) if !Dir.exists?(ed_dir)
    curr_path = current_editing_image
    FileUtils.cp(self.media.path, curr_path) if !File.exists?(curr_path)
    true
  end
  
  def leave_edit_mode(user_id)
    ed_dir = "#{self.media.folder}/editing/user_#{user_id}"
    begin
      FileUtils.rm_r(ed_dir)
    rescue
      return false
    end
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
    rescue
      return false
    end
    true
  end
  
  def undo
    return false if !self.in_edit_mode?
    prev_path = self.prev_editing_image
    curr_path = self.current_editing_image
    return false if !File.exists? prev_path
    FileUtils.rm(curr_path)
    FileUtils.cp(prev_path, curr_path)
    FileUtils.rm(prev_path)
    true
  end
  
  def add_text(texts)
    return false if !self.in_edit_mode? || !self.save_editing_prev
    img = MiniMagick::Image.open self.current_editing_image
    texts.each do |t|
      font_size = Image.ratio_value img[:width], img[:height], t[:font_size]
      coord_x = Image.ratio_value img[:width], img[:height], t[:coord_x]
      coord_y = Image.ratio_value img[:width], img[:height], t[:coord_y]
      tmp_file = Tempfile.new('textarea')
      begin
        tmp_file.write(t[:text])
        tmp_file.close
        Media::Image::Editing::AddTextToImage.new(self.current_editing_image, t[:color], font_size, coord_x, coord_y, tmp_file).run!
      ensure
        tmp_file.unlink
      end
    end
    true
  end
  
  def crop(x1, y1, x2, y2)
    return false if !self.in_edit_mode? || !self.save_editing_prev
    img = MiniMagick::Image.open self.current_editing_image
    x1 = Image.ratio_value img[:width], img[:height], x1
    y1 = Image.ratio_value img[:width], img[:height], y1
    x2 = Image.ratio_value img[:width], img[:height], x2
    y2 = Image.ratio_value img[:width], img[:height], y2
    Media::Image::Editing::Crop.new(img, self.current_editing_image, x1, y1, x2, y2).run
    true
  end
  
  def self.ratio_value(w, h, value)
    to_ratio = 660 / 500
    origin_ratio = w.to_f / h.to_f
    logger.info "\n\n\n\n\n\n w:#{w} h:#{h} \n\n\n\n\n\n"
    if origin_ratio > to_ratio
      h = w 
      w = 660 #solo questo
    else
      w = 500 #h=500
    end
    if (h.to_i > w.to_i )
      logger.info "\n\n\n\n\nvalue * h/w => w:#{w} h:#{h} \n\n\n\n\n\n"
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
