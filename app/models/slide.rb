class Slide < ActiveRecord::Base
  
  attr_accessible :position, :title, :text
  
  has_many :media_elements_slides
  belongs_to :lesson
  
  #TODO estrarre da database slide kinds
  AUDIO = 'audio'
  COVER = 'cover'
  IMAGE1 = 'image1'
  IMAGE2 = 'image2'
  IMAGE3 = 'image3'
  IMAGE4 = 'image4'
  TEXT = 'text'
  TITLE = 'title'
  VIDEO1 = 'video1'
  VIDEO2 = 'video2'
  KINDS = [COVER, TITLE, TEXT, IMAGE1, IMAGE3, IMAGE2, IMAGE4, VIDEO2, VIDEO1, AUDIO]
  KINDS_WITHOUT_COVER = [TITLE, TEXT, IMAGE1, IMAGE3, IMAGE2, IMAGE4, VIDEO2, VIDEO1, AUDIO]
  
  validates_presence_of :lesson_id, :position
  validates_numericality_of :lesson_id, :position, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => I18n.t('language_parameters.slide.length_title'), :allow_nil => true
  validates_inclusion_of :kind, :in => KINDS
  validates_uniqueness_of :position, :scope => :lesson_id
  validates_uniqueness_of :kind, :scope => :lesson_id, :if => :is_cover
  validate :validate_associations, :validate_impossible_changes, :validate_cover, :validate_text, :validate_title
  
  before_validation :init_validation
  before_destroy :stop_if_cover
  
  def cover?
    self.kind == COVER
  end
  
  def allows_title?
    [COVER, IMAGE1, AUDIO, VIDEO1, TITLE, TEXT].include?(self.kind)
  end
  
  def allows_text?
    [TEXT, IMAGE1, AUDIO, VIDEO1].include?(self.kind)
  end
  
  def accepted_media_element_sti_type
    case kind
    when ->(k) { [COVER, IMAGE1, IMAGE2, IMAGE3, IMAGE4].include?(k) }
      MediaElement::IMAGE_TYPE
    when ->(k) { [VIDEO1, VIDEO2].include?(k) }
      MediaElement::VIDEO_TYPE
    when AUDIO
      MediaElement::AUDIO_TYPE
    else
      ''
    end
  end
  
  def update_with_media_elements(title, text, media_elements)
    return false if self.new_record?
    resp = false
    ActiveRecord::Base.transaction do
      lesson = Lesson.find_by_id self.lesson_id
      raise ActiveRecord::Rollback if lesson.nil?
      self.title = title
      self.text = text
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
      resp = true
    end
    resp
  end
  
  def video_at(position)
    return nil if self.accepted_media_element_sti_type != MediaElement::VIDEO_TYPE
    x = media_element_at position
    x.nil? ? nil : x.media_element
  end
  
  def audio_at(position)
    return nil if self.accepted_media_element_sti_type != MediaElement::AUDIO_TYPE
    x = media_element_at position
    x.nil? ? nil : x.media_element
  end
  
  # this returns the record of media_elements_slides, instead of media_elements, since we need information contained in this table (alignment, caption)
  def image_at(position)
    return nil if self.accepted_media_element_sti_type != MediaElement::IMAGE_TYPE
    x = media_element_at position
    x.nil? ? nil : x
  end
  
  def previous
    self.new_record? ? nil : Slide.where(:lesson_id => self.lesson_id, :position => (self.position - 1)).first
  end
  
  def following
    self.new_record? ? nil : Slide.where(:lesson_id => self.lesson_id, :position => (self.position + 1)).first
  end
  
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
  
  private
  
  def media_element_at(position)
    MediaElementsSlide.where(:slide_id => self.id, :position => position).first
  end
  
  def validate_title
    errors[:title] << 'must be null for this kind of slide' if !self.allows_title? && !self.title.nil?
  end
  
  def validate_text
    errors[:text] << 'must be null for this kind of slide' if !self.allows_text? && !self.text.nil?
  end
  
  def is_cover
    self.kind == COVER
  end
  
  def init_validation
    @slide = Valid.get_association self, :id
    @lesson = Valid.get_association self, :lesson_id
  end
  
  def validate_associations
    errors[:lesson_id] << "doesn't exist" if @lesson.nil?
  end
  
  def validate_impossible_changes
    if @slide
      errors[:lesson_id] << "can't be changed" if @slide.lesson_id != self.lesson_id
      errors[:kind] << "can't be changed" if @slide.kind != self.kind
      errors[:title] << "if cover it can't be different by lesson's title" if @lesson && self.cover? && @slide.title != self.title && @lesson.title != self.title
    end
  end
  
  def validate_cover
    errors[:position] << "cover must be the first slide" if self.kind == COVER && self.position != 1
    errors[:position] << "if not cover can't be the first slide" if self.kind != COVER && self.position == 1
  end
  
  def stop_if_cover
    @slide = self.new_record? ? nil : Slide.where(:id => self.id).first
    return true if @slide.nil?
    return @slide.kind != COVER
  end
  
end
