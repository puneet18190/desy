# == Description
#
# ActiveRecord class that corresponds to the table +slides+.
#
# == Fields
#
# * *lesson_id*: reference to the Lesson the slide belongs to
# * *title*: title of the slide
# * *text*: text of the slide if present
# * *position*: position respect to the other slides in the lesson
# * *kind*: the kind of the slide (the type is an enum defined in postgrsql, in total there are 10 types)
# * *metadata*: contains only math images.
#
# == Associations
#
# * *lesson*: reference to the Lesson where the slide is contained (*belongs_to*)
# * *media_elements_slides*: instances of MediaElement contained in this slide (see MediaElementsSlide) (*has_many*)
# * *media_elements*: list of media elements inside the slide (see MediaElement) (through the class MediaElementsSlide) (*has_many*)
# * *documents_slides*: instances of Document contained in this slide (see DocumentsSlide) (*has_many*)
#
# == Validations
#
# * *presence* with numericality greater than zero and presence of associated record, for the field +lesson_id+
# * *presence* of +position+
# * *length*  of +title+ (value configured in the I18n translation file: if the value is greater than 255 it's set to 255); it's possible for +title+ to be +nil+
# * *inclusion* of +kind+ in the list of available kinds
# * *uniqueness* of the couple [+position+, +lesson_id+]
# * *uniqueness* of the couple [+kind+, +lesson_id+] <b>only if the slide is of kind +cover+</b>
# * *modifications* *not* *allowed* for the fields +lesson_id+, +kind+, +title+
# * *the* *position* of the cover must be 1; on the other side, the position of other kinds of slides can't be 1
# * *the* *text* must be +nil+ if the kind of slide doesn't contain text
# * *the* *title* must be +nil+ if the kind of slide doesn't contain title
# * *the* *maximum* *number* of slides must be the one configured in settings.yml. This validation uses Lesson#reached_the_maximum_of_slides?
#
# == Callbacks
#
# 1. *before_destroy* stop the destruction if the slide is of kind 'cover'
#
# == Database callbacks
#
# 1. *cascade* *destruction* for the associated table MediaElementsSlide
# 2. *cascade* *destruction* for the associated table DocumentsSlide
#
class Slide < ActiveRecord::Base
  include ActionView::Helpers
  
  attr_accessible :position, :title, :text
  
  has_many :media_elements_slides
  has_many :media_elements, through: :media_elements_slides
  belongs_to :lesson
  has_many :documents_slides
  
  # Slide of kind 'audio': it contains
  # 1. a title
  # 2. an audio track
  # 3. a text
  AUDIO = 'audio'
  
  # Slide of kind 'cover': it contains
  # 1. the title of the Lesson
  # 2. SchoolLevel, User author, Subject
  # 3. an image
  COVER = 'cover'
  
  # Slide of kind 'image1': it contains
  # 1. a title
  # 2. an image
  # 3. a text
  IMAGE1 = 'image1'
  
  # Slide of kind 'image2': it contains
  # 1. two images of medium size
  IMAGE2 = 'image2'
  
  # Slide of kind 'image3': it contains
  # 1. a single image in fullscreen
  IMAGE3 = 'image3'
  
  # Slide of kind 'image4': it contains
  # 1. four images of small size
  IMAGE4 = 'image4'
  
  # Slide of kind 'text': it contains
  # 1. a title
  # 2. a text
  TEXT = 'text'
  
  # Slide of kind 'title': it contains
  # 1. a big centered title
  TITLE = 'title'
  
  # Slide of kind 'video1': it contains
  # 1. a title
  # 2. a small video
  # 3. a text
  VIDEO1 = 'video1'
  
  # Slide of kind 'video2': it contains
  # 1. a video in fullscreen
  VIDEO2 = 'video2'
  
  # List of kinds excepting the cover
  KINDS_WITHOUT_COVER = [TITLE, TEXT, IMAGE1, IMAGE3, IMAGE2, IMAGE4, VIDEO2, VIDEO1, AUDIO]
  
  # Complete list of kinds
  KINDS = KINDS_WITHOUT_COVER + [COVER]
  
  # Maximum length of the title
  MAX_COVER_TITLE_LENGTH = (I18n.t('language_parameters.lesson.length_title') > 255 ? 255 : I18n.t('language_parameters.lesson.length_title'))
  
  serialize :metadata, OpenStruct

  validates_presence_of :lesson_id, :position
  validates_numericality_of :lesson_id, :position, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => 255, :allow_nil => true, unless: proc{ cover? }
  validates_length_of :title, :maximum => MAX_COVER_TITLE_LENGTH, :allow_nil => true, if: proc{ cover? }
  validates_inclusion_of :kind, :in => KINDS
  validates_uniqueness_of :position, :scope => :lesson_id
  validates_uniqueness_of :kind, :scope => :lesson_id, :if => :is_cover
  validate :validate_associations, :validate_impossible_changes, :validate_cover, :validate_text, :validate_title, :validate_max_number_slides, :validate_math_images
  
  before_validation :init_validation
  before_update :save_math_images
  before_create :init_math_images_copy
  after_create :copy_math_images
  before_destroy :stop_if_cover, :remove_math_images_folder

  def math_images
    return metadata.math_images = MathImages.new([], id) unless metadata.math_images

    metadata.math_images.model_id = id if id && !metadata.math_images.model_id

    metadata.math_images
  end

  def math_images=(math_images)
    metadata.math_images = math_images.is_a?(MathImages) ? math_images : MathImages.new(math_images, id)
  end

  def self.last_of_lesson(lesson)
    order('position DESC').where(:lesson_id => lesson.id).first
  end

  # Used to center vertically the title
  def title=(title)
    if self.kind == TITLE && !title.blank? && title.first == "\r"
      write_attribute(:title, " #{title}")
    else
      write_attribute(:title, title)
    end
  end
  
  # Used to sanitize texts from TinyMCE
  def text=(text)
    text = text.nil? ? nil : text.to_s
    write_attribute(:text, sanitize(text, attributes: (HTML::WhiteListSanitizer.allowed_attributes + ['style'])))
  end
  
  # === Description
  #
  # Checks if the slide is of kind 'cover'
  #
  # === Returns
  #
  # A boolean
  #
  def cover?
    self.kind == COVER
  end
  
  # === Description
  #
  # Checks if the +kind+ of this slide allows a title (used in the validations of this model).
  #
  # === Returns
  #
  # A boolean
  #
  def allows_title?
    case kind
    when COVER, IMAGE1, AUDIO, VIDEO1, TITLE, TEXT then true
    else false
    end
  end
  
  # === Description
  #
  # Checks if the +kind+ of this slide allows an attached document (see DocumentsSlide).
  #
  # === Returns
  #
  # A boolean
  #
  def allows_document?
    self.allows_title? && ![TITLE, COVER].include?(self.kind)
  end
  
  # === Description
  #
  # Checks if the +kind+ of this slide allows a text (used in the validations of this model).
  #
  # === Returns
  #
  # A boolean
  #
  def allows_text?
    case kind
    when TEXT, IMAGE1, AUDIO, VIDEO1 then true
    else false
    end
  end
  
  # === Description
  #
  # Returns the accepted sti_type for instances of MediaElement contained in this slide through MediaElementsSlide (in which model it's used for validations). If no media element is available, it returns nil.
  #
  # === Returns
  #
  # A string representing MediaElement sti_types, or nil
  #
  def accepted_media_element_sti_type
    case kind
    when COVER, IMAGE1, IMAGE2, IMAGE3, IMAGE4
      MediaElement::IMAGE_TYPE
    when VIDEO1, VIDEO2
      MediaElement::VIDEO_TYPE
    when AUDIO
      MediaElement::AUDIO_TYPE
    else
      ''
    end
  end
  
  # === Description
  #
  # Method that performs the list of actions related to the update of a slide's content:
  # * updates title and text
  # * for each media element in the slide, checks if it's already present: if so, it's updated, otherwise it's created
  # * if the lesson is public, each private element added is turned into public too
  # * calls Lesson.modify
  #
  # === Args
  #
  # * *title*: title (it might be +nil+)
  # * *text*: text (it might be +nil+)
  # * *media_elements*: a hash of arrays. Each item of this argument represents a media element in the position given by +index+ + 1 in the hash. Each small array contains (in order):
  #   * *media_element_id*: corresponds to the id of the MediaElement associated
  #   * *alignment*: corresponds to the field +alignment+ of MediaElementsSlide
  #   * *caption*: corresponds to the field +caption+ of MediaElementsSlide
  # * *documents*: an array of integers. Each item of this argument represents a document
  # * *math_images*: math images.
  #
  # === Returns
  #
  # A boolean
  #
  # === Usage
  #
  # See LessonEditorController#save_slide, LessonEditorController#save_slide_and_exit, LessonEditorController#save_slide_and_edit
  #   slide.update_with_media_elements((params[:title].blank? ? nil : params[:title]), (params[:text].blank? ? nil : params[:text]), media_elements_params)
  #
  def update_with_media_elements(title, text, media_elements, documents, math_images)
    return false if self.new_record?
    resp = false
    ActiveRecord::Base.transaction do
      lesson = Lesson.find_by_id self.lesson_id
      raise ActiveRecord::Rollback if lesson.nil?
      self.title = title
      self.text = text
      self.math_images = math_images if math_images
      raise ActiveRecord::Rollback if !lesson.modify
      raise ActiveRecord::Rollback if !self.save
      media_elements.each do |k, v|
        mes = MediaElementsSlide.where(:position => k, :slide_id => self.id).first
        if mes.nil?
          mes2 = MediaElementsSlide.new
          mes2.position = k
          mes2.slide_id = self.id
          mes2.media_element_id = v[0]
          mes2.alignment = v[1]
          mes2.caption = v[2]
          raise ActiveRecord::Rollback if !mes2.save
        elsif [mes.media_element_id, mes.alignment, mes.caption] != v
          mes.media_element_id = v[0]
          mes.alignment = v[1]
          mes.caption = v[2]
          raise ActiveRecord::Rollback if !mes.save
        end
        my_media_element = MediaElement.find_by_id v[0]
        raise ActiveRecord::Rollback if my_media_element.nil?
        if lesson.is_public && !my_media_element.is_public
          my_media_element.is_public = true
          my_media_element.publication_date = Time.zone.now
          raise ActiveRecord::Rollback if !my_media_element.save
          boo = Bookmark.new
          boo.user_id = my_media_element.user_id
          boo.bookmarkable_type = 'MediaElement'
          boo.bookmarkable_id = my_media_element.id
          raise ActiveRecord::Rollback if !boo.save
        end
      end
      (documents.empty? ? DocumentsSlide.where(:slide_id => self.id) : DocumentsSlide.where('slide_id = ? AND document_id NOT IN (?)', self.id, documents)).each do |d|
        d.destroy
      end
      documents.each do |doc|
        ds = DocumentsSlide.where(:slide_id => self.id, :document_id => doc).first
        if ds.nil?
          ds2 = DocumentsSlide.new
          ds2.slide_id = self.id
          ds2.document_id = doc
          raise ActiveRecord::Rollback if !ds2.save
        end
      end
      raise ActiveRecord::Rollback if DocumentsSlide.where(:slide_id => self.id).pluck(:document_id).sort != documents.sort
      resp = true
    end
    resp
  end
  
  # === Description
  #
  # Returns the record of Video, obtained through MediaElementsSlide, associated to the given position. If the position is not valid, or there is no video in that position, it returns +nil+
  #
  # === Args
  #
  # * *position*: the position requested
  #
  # === Returns
  #
  # Either an object of type Video, or +nil+
  #
  def video_at(position)
    return nil if self.accepted_media_element_sti_type != MediaElement::VIDEO_TYPE
    x = media_element_at position
    x.nil? ? nil : x.media_element
  end
  
  # === Description
  #
  # Returns the record of Audio, obtained through MediaElementsSlide, associated to the given position. If the position is not valid, or there is no audio in that position, it returns +nil+
  #
  # === Args
  #
  # * *position*: the position requested
  #
  # === Returns
  #
  # Either an object of type Audio, or +nil+
  #
  def audio_at(position)
    return nil if self.accepted_media_element_sti_type != MediaElement::AUDIO_TYPE
    x = media_element_at position
    x.nil? ? nil : x.media_element
  end
  
  # === Description
  #
  # Returns the MediaElementsSlide, associated to an Image in the given position. If the position is not valid, or there is no image in that position, it returns +nil+. Notice that, unlike Slide#video_at and Slide#audio_at, this method returns an instance of MediaElementsSlide rather than of MediaElement.
  #
  # === Args
  #
  # * *position*: the position requested
  #
  # === Returns
  #
  # Either an object of type MediaElementsSlide, or +nil+
  #
  def image_at(position)
    return nil if self.accepted_media_element_sti_type != MediaElement::IMAGE_TYPE
    x = media_element_at position
    x.nil? ? nil : x
  end
  
  # === Description
  #
  # Returns the previous slide if any
  #
  # === Returns
  #
  # Either an object of type Slide or +nil+
  #
  def previous
    self.new_record? ? nil : Slide.where(:lesson_id => self.lesson_id, :position => (self.position - 1)).first
  end
  
  # === Description
  #
  # Returns the following slide if any
  #
  # === Returns
  #
  # Either an object of type Slide or +nil+
  #
  def following
    self.new_record? ? nil : Slide.where(:lesson_id => self.lesson_id, :position => (self.position + 1)).first
  end
  
  # === Description
  #
  # Destroys the slide keeping updated the position of the other slides in the same lesson. It's not suggested to use the original method destroy. Used in LessonEditorController#delete_slide
  #
  # === Returns
  #
  # A boolean
  #
  def destroy_with_positions
    return false if self.new_record?
    return false if self.kind == COVER
    resp = false
    my_position = self.position
    my_lesson_id = self.lesson_id
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback if !self.lesson.modify
      begin
        self.destroy
      rescue StandardError
        raise ActiveRecord::Rollback
      end
      Slide.where('lesson_id = ? AND position > ?', my_lesson_id, my_position).order(:position).each do |s|
        s.position -= 1
        raise ActiveRecord::Rollback if !s.save
      end
      resp = true
    end
    resp
  end
  
  # === Description
  #
  # Changes the position of the slide. If the given position is not valid (<= 1, or > number of slides in the lesson) it does nothing. Used in LessonEditorController#change_slide_position
  #
  # === Args
  #
  # * *position*: the new position of the slide
  #
  # === Returns
  #
  # A boolean
  #
  def change_position(x)
    return false if self.new_record?
    return false if x.class != Fixnum || x < 1
    y = self.position
    return true if y == x
    desc = (y > x)
    return false if self.kind == COVER
    tot_slides = Slide.where(:lesson_id => self.lesson_id).count
    return false if x > tot_slides || x == 1
    resp = false
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback if !self.lesson.modify
      self.position = tot_slides + 2
      raise ActiveRecord::Rollback if !self.save
      empty_pos = y
      while empty_pos != x
        curr_pos = (desc ? (empty_pos - 1) : (empty_pos + 1))
        curr_slide = Slide.where(:lesson_id => self.lesson_id, :position => curr_pos).first
        curr_slide.position = empty_pos
        raise ActiveRecord::Rollback if !curr_slide.save
        empty_pos = curr_pos
      end
      self.position = x
      raise ActiveRecord::Rollback if !self.save
      resp = true
    end
    resp
  end
  
  # === Description
  #
  # Method that extracts the slide adhiacent to this, according to the 'circular' order used in lesson viewer (see LessonViewerController). It the current slide is the last and you apply the method to get the next one, it returns back the first.
  #
  # === Args
  #
  # * *an_user_id*: the id of the User who is viewing the lesson (it's used only to extract the VirtualClassroomLesson, not to make any security control about the current slide: such controls are achieved in LessonViewerController#skip_authenticate_user_if_token_with_three_slides)
  # * *with_playlist*: if true, the method uses the virtual classroom of the user to get the next slide, in case this slide is the last of its lesson
  # * *is_previous*: if true, the method gets the previoius slide, otherwise the following one
  #
  # === Returns
  #
  # An object of kind Slide, or nil (only if +with_playlist+ is +true+ and the lesson to which this slide belongs is not included in the user's virtual classroom)
  #
  def get_adhiacent_slide_in_lesson_viewer(an_user_id, with_playlist, is_previous)
    resp = is_previous ? self.previous : self.following
    return resp if !resp.nil?
    if with_playlist
      vcl = VirtualClassroomLesson.where(:user_id => an_user_id, :lesson_id => self.lesson_id).first
      return nil if vcl.nil? || vcl.position.nil?
      new_position = is_previous ? (vcl.position - 1) : (vcl.position + 1)
      new_vcl = VirtualClassroomLesson.where(:user_id => an_user_id, :position => new_position).first
      new_vcl = get_last_or_first(VirtualClassroomLesson.order('position ASC').where('user_id = ? AND position IS NOT NULL', an_user_id), is_previous) if new_vcl.nil?
      return get_last_or_first(new_vcl.lesson.slides.order('position ASC'), is_previous)
    end
    get_last_or_first(self.lesson.slides.order('position ASC'), is_previous)
  end
  
  private
  
  # Submethod of Slide#get_adhiacent_slide_in_lesson_viewer
  def get_last_or_first(query, last)
    last ? query.last : query.first
  end
  
  # Validates that the lesson is not exceeding the maximum number of slides
  def validate_max_number_slides
    errors.add(:base, :too_many_slides) if @lesson && !@slide && Slide.where(:lesson_id => @lesson.id).count == SETTINGS['max_number_slides_in_a_lesson']
  end
  
  # Extracts the media element at a given position
  def media_element_at(position)
    MediaElementsSlide.where(:slide_id => self.id, :position => position).first
  end
  
  # Validates that if the slide doesn't allow the +title+, it must be +nil+
  def validate_title
    errors.add(:title, :must_be_null_in_this_slide) if !self.allows_title? && !self.title.nil?
  end
  
  # Validates that if the slide doesn't allow the +text+, it must be +nil+
  def validate_text
    errors.add(:text, :must_be_null_in_this_slide) if !self.allows_text? && !self.text.nil?
  end
  
  # Checks if the slide is the cover of the lesson
  def is_cover
    self.kind == COVER
  end
  
  # Initializes validation objects (see Valid.get_association)
  def init_validation
    @slide = Valid.get_association self, :id
    @lesson = Valid.get_association self, :lesson_id
  end
  
  # Validates the presence of all the associated objects
  def validate_associations
    errors.add(:lesson_id, :doesnt_exist) if @lesson.nil?
  end
  
  # If the slide is not a new record, +lesson_id+ and +kind+ can't be changed; moreover, if it's the cover, the title can't be different by the title of the lesson
  def validate_impossible_changes
    if @slide
      errors.add(:lesson_id, :cant_be_changed) if @slide.lesson_id != self.lesson_id
      errors.add(:kind, :cant_be_changed) if @slide.kind != self.kind
      errors.add(:title, :in_cover_it_cant_be_different_by_lessons_title) if @lesson && self.cover? && @slide.title != self.title && @lesson.title != self.title
    end
  end
  
  def validate_cover
    errors.add(:position, :cover_must_be_first_slide) if self.kind == COVER && self.position != 1
    errors.add(:position, :if_not_cover_cant_be_first_slide) if self.kind != COVER && self.position == 1
  end
  
  def stop_if_cover
    @slide = self.new_record? ? nil : Slide.where(:id => self.id).first
    return true if @slide.nil?
    return @slide.kind != COVER
  end

  def remove_math_images_folder
    math_images.remove_folder
  end

  def save_math_images
    math_images.save
    true
  end

  def validate_math_images
    if !math_images.is_a?(MathImages)                                                  ||
       math_images.invalid?                                                            ||
       ( persisted? && math_images.model_id != id )                                    ||
       ( new_record? && math_images.model_id && !Slide.exists?(math_images.model_id) )
      errors.add :math_images, :invalid
    end
  end


  def init_math_images_copy
    if math_images.model_id
      @math_images_copy_id = math_images.model_id
      math_images.model_id = nil
    end
    true
  end

  def copy_math_images
    return true unless @math_images_copy_id
    self.math_images = Slide.find(@math_images_copy_id).math_images.copy_to(id)
  end
  
end
