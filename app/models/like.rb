class Like < ActiveRecord::Base
  
  belongs_to :lesson
  belongs_to :user
  
  validates_presence_of :lesson_id, :user_id
  validates_numericality_of :lesson_id, :user_id, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :lesson_id, :scope => :user_id
  validate :validate_associations, :validate_impossible_changes, :validate_availability
  
  before_validation :init_validation
  
  private
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
    errors[:lesson_id] << "doesn't exist" if !Lesson.exists?(self.lesson_id)
  end
  
  def init_validation
    @like = Valid.get_association self, :id
    @lesson = Valid.get_association self, :lesson_id
    @user = Valid.get_association self, :user_id
  end
  
  def validate_impossible_changes
    if @like
      errors[:user_id] << "can't be changed" if @like.user_id != self.user_id
      errors[:lesson_id] << "can't be changed" if @like.lesson_id != self.lesson_id
    end
  end
  
  def validate_availability
    errors[:lesson_id] << "can't be liked" if @lesson && @user && @lesson.user_id == @user.id
  end
  
end
