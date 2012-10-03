class VirtualClassroomLesson < ActiveRecord::Base
  
  attr_accessible :position
  
  belongs_to :user
  belongs_to :lesson
  
  validates_presence_of :lesson_id, :user_id
  validates_numericality_of :lesson_id, :user_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :position, :allow_nil => true, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :lesson_id, :scope => :user_id
  validates_uniqueness_of :position, :scope => :user_id, :if => :in_playlist?
  validate :validate_associations, :validate_availability, :validate_copied_not_modified, :validate_impossible_changes, :validate_positions
  
  before_validation :init_validation
  
  def in_playlist?
    return false if self.new_record?
    !self.position.blank?
  end
  
  private
  
  def init_validation
    @virtual_classroom_lesson = Valid.get_association self, :id
    @lesson = Valid.get_association self, :lesson_id
    @user = Valid.get_association self, :user_id
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
    errors[:lesson_id] << "doesn't exist" if !Lesson.exists?(self.lesson_id)
  end
  
  def validate_availability
    errors[:lesson_id] << 'is not available' if @lesson && @user && @lesson.user_id != @user.id && !@lesson.bookmarked?(@user.id)
  end
  
  def validate_copied_not_modified
    errors[:lesson_id] << 'has just been copied' if @lesson && @lesson.copied_not_modified
  end
  
  def validate_positions
    errors[:position] << 'must be null if new record' if self.new_record? && self.position
  end
  
  def validate_impossible_changes
    if @virtual_classroom_lesson
      errors[:user_id] << "can't be changed" if @virtual_classroom_lesson.user_id != self.user_id
      errors[:lesson_id] << "can't be changed" if @virtual_classroom_lesson.lesson_id != self.lesson_id
    end
  end
  
end
