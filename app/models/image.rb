require 'shellwords'
require 'media/image/editing/add_text_to_image'
require 'media/image/editing/crop'

# == Description
#
# This class inherits from MediaElement, and contains the specific methods needed for media elements of type +image+.
# 
class Image < MediaElement
  
  # List of accepted extensions for an image
  EXTENSION_WHITE_LIST = ImageUploader::EXTENSION_WHITE_LIST
  # Extensions globbing for finding images with <tt>Dir.glob</tt>
  EXTENSIONS_GLOB      = "*.{#{EXTENSION_WHITE_LIST.join(',')}}"
  
  mount_uploader :media, ImageUploader
  
  before_save :set_width_and_height
  before_create :set_converted_to_true
  
  attr_reader :edit_mode
  
  # === Description
  #
  # Returns the url of the attached image.
  #
  # === Returns
  #
  # An url
  #
  # === Usage
  #
  #   <%= image_tag image.url %>
  #
  def url
    media.url
  end
  
  # === Description
  #
  # Returns the url of the 200x200 thumb of the attached image.
  #
  # === Returns
  #
  # An url
  #
  # === Usage
  #
  #   <%= image_tag image.thumb_url %>
  #
  def thumb_url
    media.thumb.url
  end
  
  # === Description
  #
  # Returns the width in pixels.
  #
  # === Returns
  #
  # A float.
  #
  def width
    metadata.width
  end
  
  # === Description
  #
  # Returns the height in pixels.
  #
  # === Returns
  #
  # A float.
  #
  def height
    metadata.height
  end
  
  # === Description
  #
  # Returns the url of the folder where it's conserved the temporary image during editing.
  #
  # === Returns
  # An url.
  #
  def editing_url
    return '' if !self.in_edit_mode?
    file_name = "/#{url.split('/').last}"
    "#{url.gsub(file_name, '')}/editing/user_#{@edit_mode}/tmp.#{self.media.file.extension}"
  end
  
  # === Description
  #
  # Returns the path of the previous step conserved in image editor: this replaces the current step if the user clicks on 'undo'
  #
  # === Returns
  #
  # A path.
  #
  def prev_editing_image
    return '' if !self.in_edit_mode?
    "#{self.media.folder}/editing/user_#{@edit_mode}/prev.#{self.media.file.extension}"
  end
  
  # === Description
  #
  # Returns the path of the current step conserved in image editor.
  #
  # === Returns
  #
  # A path.
  #
  def current_editing_image
    return '' if !self.in_edit_mode?
    "#{self.media.folder}/editing/user_#{@edit_mode}/tmp.#{self.media.file.extension}"
  end
  
  # === Description
  #
  # Used to check if the image is in *edit* *mode*: the image enters in edit mode when the image editor is opened, this implies that a temporary folder is automaticly created to contain the progressive steps of the editing. This method is useful to deny the access to specific methods if the image is not in editing.
  #
  # === Returns
  #
  # A boolean.
  #
  # === Usage
  #
  #   return '' if !self.in_edit_mode?
  #
  def in_edit_mode?
    !@edit_mode.nil?
  end
  
  # === Description
  #
  # The image enters in *edit* *mode* for a particular user (who is not necessarily the creator of the image, this is checked in the controller). Used in ImageEditorController.
  #
  # === Arguments
  #
  # * *user_id*: id of the user who is editing the image
  #
  def enter_edit_mode(user_id)
    @edit_mode = user_id
    ed_dir = "#{self.media.folder}/editing/user_#{@edit_mode}"
    FileUtils.mkdir_p(ed_dir) if !Dir.exists?(ed_dir)
    curr_path = current_editing_image
    FileUtils.cp(self.media.path, curr_path) if !File.exists?(curr_path)
    true
  end
  
  # === Description
  #
  # The image leaves the *edit* *mode* for a particular user. Used in ImageEditorController#edit.
  #
  # === Arguments
  #
  # * *user_id*: id of the user who is editing the image
  #
  # === Returns
  #
  # True if the user was in editing mode, false otherwise.
  #
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
  
  # === Description
  #
  # Copies the current temporary image into the previous temporary image.
  #
  # === Returns
  #
  # A boolean.
  #
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
  
  # === Description
  #
  # Copies the previous temporary image into the current temporary image. Used in ImageEditorController#undo.
  #
  # === Returns
  #
  # A boolean.
  #
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
  
  # === Description
  #
  # Adds multiple texts in the temporary image. Used in ImageEditorController#add_text
  #
  # === Arguments
  #
  # * *texts*: an array of hashes, one for each text added. Each hash has the keys
  #   * +font_size+: the font size
  #   * +coord_x+: horizontal coordinates of the top left corner of the text
  #   * +coord_y+: vertical coordinates of the top left corner of the text
  #   * +color+: hexagonal color of the text
  #
  # === Returns
  #
  # A boolean.
  #
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
  
  # === Description
  #
  # Crops the temporary image. Used in ImageEditorController#crop
  #
  # === Arguments
  #
  # * *x1*: horizontal coordinate of the top left corner of the crop
  # * *y1*: vertical coordinate of the top left corner of the crop
  # * *x2*: horizontal coordinate of the bottom right corner of the crop
  # * *y2*: vertical coordinate of the bottom right corner of the crop
  #
  # === Returns
  #
  # A boolean.
  #
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
  
  # === Description
  #
  # Returns the original value of a coordinate, given the actual value and the size of the image
  #
  # === Arguments
  #
  # * *w*: width of the image
  # * *h*: height of the image
  # * *value*: value to be scaled
  #
  # === Returns
  #
  # A float.
  #
  def self.ratio_value(w, h, value)
    to_ratio = 660.to_f / 500.to_f
    origin_ratio = w.to_f / h.to_f
    if origin_ratio > to_ratio
      h = w
      w = 660
    else
      w = 500
    end
    if (h.to_i > w.to_i )
      return value.to_f * (h.to_f / w.to_f)
    else
      return value
    end
  end
  
  private
  
  # Sets the +width+ in +metadata+
  def width=(width) # :doc:
    metadata.width = width
  end
  
  # Sets the +height+ in +metadata+
  def height=(height) # :doc:
    metadata.height = height
  end
  
  # Sets +width+ and +height+ according to the data contained in +media+
  def set_width_and_height # :doc:
    self.width, self.height = media.width, media.height
    true
  end
  
  # Sets +converted+ to true
  def set_converted_to_true # :doc:
    self.converted = true
    true
  end
  
end
