class Slide < ActiveRecord::Base
  
  attr_accessible :position, :title, :text1, :text2
  
  has_many :media_elements_slides
  belongs_to :lesson
  
  validates_presence_of :lesson_id, :position
  validates_numericality_of :lesson_id, :position, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => 255, :allow_nil => true
  validates_inclusion_of :kind, :in => ['cover', 'text1', 'text2', 'image1', 'image2', 'image3', 'audio1', 'audio2', 'video1', 'video2']
  validates_uniqueness_of :position, :scope => :lesson_id
  validates_uniqueness_of :kind, :scope => :lesson_id, :if => :is_cover
  validate :validate_associations, :validate_impossible_changes, :validate_text2, :validate_cover, :validate_previous_positions
  
  before_validation :init_validation
  before_destroy :stop_if_cover
  
  private
  
  def is_cover
    self.kind == 'cover'
  end
  
  def init_validation
    @slide = self.new_record? ? nil : Slide.where(:id => self.id).first
    @lesson = self.lesson_id.blank? ? nil : Lesson.where(:id => self.lesson_id).first
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
  
  def validate_text2
    errors[:text2] << 'must be null if slide is not of kind text2' if !self.text2.blank? && self.kind != 'text2'
  end
  
  def stop_if_cover
    @slide = self.new_record? ? nil : Slide.where(:id => self.id).first
    return true if @slide.nil?
    return @slide.kind != 'cover'
  end
  
  def validate_previous_positions
    if @lesson && !self.position_id.blank?
      flag = false
      i = 1
      while i < my_position
        flag = true if Slide.where(:lesson_id => self.lesson_id, :position => i).empty?
        i += 1
      end
      errors[:position] << "there is one missing" if flag
    end
  end
  
end
