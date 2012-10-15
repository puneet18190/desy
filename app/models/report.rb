class Report < ActiveRecord::Base
  
  belongs_to :reportable, :polymorphic => true
  belongs_to :user
  
  validates_presence_of :user_id, :reportable_id, :comment
  validates_numericality_of :user_id, :reportable_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :reportable_type, :in => ['Lesson', 'MediaElement']
  validates_uniqueness_of :reportable_id, :scope => [:user_id, :reportable_type], :if => :good_reportable_type
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation
  
  private
  
  def good_reportable_type
    ['Lesson', 'MediaElement'].include? self.reportable_type
  end
  
  def init_validation
    @report = Valid.get_association self, :id
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
    errors[:reportable_id] << "lesson doesn't exist" if self.reportable_type == 'Lesson' && !Lesson.exists?(self.reportable_id)
    errors[:reportable_id] << "media element doesn't exist" if self.reportable_type == 'MediaElement' && !MediaElement.exists?(self.reportable_id)
  end
  
  def validate_impossible_changes
    if @report
      errors[:user_id] << "can't be changed" if self.user_id != @report.user_id
      errors[:reportable_id] << "can't be changed" if self.reportable_id != @report.reportable_id
      errors[:reportable_type] << "can't be changed" if self.reportable_type != @report.reportable_type
      errors[:comment] << "can't be changed" if self.comment != @report.comment
    end
  end
  
end
