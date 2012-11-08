class Slide < ActiveRecord::Base
  
  attr_accessible :position, :title, :text
  
  has_many :media_elements_slides
  belongs_to :lesson
  
  #TODO estrarre da database slide kinds
  KINDS = ['cover', 'title', 'text', 'image1', 'image3', 'image2', 'image4', 'video2', 'video1', 'audio']
  
  validates_presence_of :lesson_id, :position
  validates_numericality_of :lesson_id, :position, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => I18n.t('language_parameters.slide.length_title'), :allow_nil => true
  validates_inclusion_of :kind, :in => KINDS
  validates_uniqueness_of :position, :scope => :lesson_id
  validates_uniqueness_of :kind, :scope => :lesson_id, :if => :is_cover
  validate :validate_associations, :validate_impossible_changes, :validate_cover, :validate_text, :validate_title
  
  before_validation :init_validation
  before_destroy :stop_if_cover
  
  def has_media_element?(position)
    MediaElementsSlide.where(:slide_id => self.id, :position => position).first
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
    if self.kind == 'cover'
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
    if self.kind == 'cover'
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
  
  def validate_title
    errors[:title] << 'must be null for this kind of slide' if ['image2', 'image3', 'image4', 'video2'].include?(self.kind) && !self.title.nil?
  end
  
  def validate_text
    errors[:text] << 'must be null for this kind of slide' if ['cover', 'title', 'image2', 'image3', 'image4', 'video2'].include?(self.kind) && !self.text.nil?
  end
  
  def is_cover
    self.kind == 'cover'
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
    errors[:position] << "cover must be the first slide" if self.kind == 'cover' && self.position != 1
    errors[:position] << "if not cover can't be the first slide" if self.kind != 'cover' && self.position == 1
  end
  
  def stop_if_cover
    @slide = self.new_record? ? nil : Slide.where(:id => self.id).first
    return true if @slide.nil?
    return @slide.kind != 'cover'
  end
  
end
