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
  
  def allows_title?
    [COVER, IMAGE1, AUDIO, VIDEO1, TITLE, TEXT].include?(self.kind)
  end
  
  def allows_text?
    [TEXT, IMAGE1, AUDIO, VIDEO1].include?(self.kind)
  end
  
  def accepted_media_element_sti_type
    if [COVER, IMAGE1, IMAGE2, IMAGE3, IMAGE4].include?(self.kind)
      return MediaElement::IMAGE_TYPE
    elsif [VIDEO1, VIDEO2].include?(self.kind)
      return MediaElement::VIDEO_TYPE
    elsif self.kind == AUDIO
      return MediaElement::AUDIO_TYPE
    else
      return ''
    end
  end
  
  def update_with_media_elements(title, text, media_elements)
    return false if self.new_record?
    resp = false
    ActiveRecord::Base.transaction do
      self.title = title
      self.text = text
      raise ActiveRecord::Rollback if !self.save
      media_elements.each do |k, v|
        mes = MediaElementsSlide.where(:position => k, :slide_id => self.id).first
        if mes.nil? || [mes.media_element_id, mes.alignment, mes.caption] != v
          mes.destroy if !mes.nil?
          mes2 = MediaElementsSlide.new
          mes2.position = k
          mes2.slide_id = self.id
          mes2.media_element_id = v[0]
          mes2.alignment = v[1]
          mes2.caption = v[2]
          raise ActiveRecord::Rollback if !mes2.save
        end
      end
      resp = true
    end
    resp
  end
  
  def media_element_url_at(position) # TODO aggiungi altezza e larghezza
    x = media_element_at position
    url = x.nil? ? nil : x.media_element.media.url
    alignment = x.nil? ? nil : x.alignment
    caption = x.nil? ? nil : x.caption
    media_element_id = x.nil? ? nil : x.media_element_id
    return {:empty => x.nil?, :url => url, :alignment => alignment, :caption => caption, :media_element_id => media_element_id}
  end
  
  def previous
    self.new_record? ? nil : Slide.where(:lesson_id => self.lesson_id, :position => (self.position - 1)).first
  end
  
  def following
    self.new_record? ? nil : Slide.where(:lesson_id => self.lesson_id, :position => (self.position + 1)).first
  end
  
  def destroy_with_positions
    errors.clear
    if self.new_record?
      errors.add(:base, :problems_destroying)
      return false
    end
    if self.kind == COVER
      errors.add(:base, :dont_destroy_cover)
      return false
    end
    resp = false
    my_position = self.position
    my_lesson_id = self.lesson_id
    ActiveRecord::Base.transaction do
      begin
        self.destroy
      rescue Exception
        errors.add(:base, :problems_destroying)
        raise ActiveRecord::Rollback
      end
      Slide.where('lesson_id = ? AND position > ?', my_lesson_id, my_position).order(:position).each do |s|
        s.position -= 1
        if !s.save
          errors.add(:base, :problems_destroying)
          raise ActiveRecord::Rollback
        end
      end
      resp = true
    end
    resp
  end
  
  def change_position(x)
    errors.clear
    if self.new_record?
      errors.add(:base, :problems_changing_position)
      return false
    end
    if x.class != Fixnum || x < 1
      errors.add(:base, :invalid_position)
      return false
    end
    y = self.position
    return true if y == x
    desc = (y > x)
    if self.kind == COVER
      errors.add(:base, :cant_change_position_of_cover)
      return false
    end
    tot_slides = Slide.where(:lesson_id => self.lesson_id).count
    if x > tot_slides || x == 1
      errors.add(:base, :invalid_position)
      return false
    end
    resp = false
    ActiveRecord::Base.transaction do
      self.position = tot_slides + 2
      if !self.save
        errors.add(:base, :problems_changing_position)
        raise ActiveRecord::Rollback
      end
      empty_pos = y
      while empty_pos != x
        curr_pos = (desc ? (empty_pos - 1) : (empty_pos + 1))
        curr_slide = Slide.where(:lesson_id => self.lesson_id, :position => curr_pos).first
        curr_slide.position = empty_pos
        if !curr_slide.save
          errors.add(:base, :problems_changing_position)
          raise ActiveRecord::Rollback
        end
        empty_pos = curr_pos
      end
      self.position = x
      if !self.save
        errors.add(:base, :problems_changing_position)
        raise ActiveRecord::Rollback
      end
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
  end
  
  def validate_associations
    errors[:lesson_id] << "doesn't exist" if !Lesson.exists?(self.lesson_id)
  end
  
  def validate_impossible_changes
    if @slide
      errors[:lesson_id] << "can't be changed" if @slide.lesson_id != self.lesson_id
      errors[:kind] << "can't be changed" if @slide.kind != self.kind
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
