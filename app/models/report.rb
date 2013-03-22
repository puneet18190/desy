class Report < ActiveRecord::Base
  
  belongs_to :reportable, :polymorphic => true
  belongs_to :user
  
  validates_presence_of :user_id, :reportable_id, :comment
  validates_numericality_of :user_id, :reportable_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :reportable_type, :in => ['Lesson', 'MediaElement']
  validates_uniqueness_of :reportable_id, :scope => [:user_id, :reportable_type], :if => :good_reportable_type
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation
  
  def accept
    to_be_destroyed = self.reportable
    to_be_destroyed.destroyable_even_if_public = true if self.reportable_type == 'MediaElement'
    to_be_destroyed.destroy
    self.destroy
  end
  
  def decline
    self.destroy
  end
  
  private
  
  def good_reportable_type
    ['Lesson', 'MediaElement'].include? self.reportable_type
  end
  
  def init_validation
    @report = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
    @lesson = self.reportable_type == 'Lesson' ? Valid.get_association(self, :reportable_id, Lesson) : nil
    @media_element = self.reportable_type == 'MediaElement' ? Valid.get_association(self, :reportable_id, MediaElement) : nil
  end
  
  def validate_associations
    errors.add(:user_id, :doesnt_exist) if @user.nil?
    errors.add(:reportable_id, :lesson_doesnt_exist) if self.reportable_type == 'Lesson' && @lesson.nil?
    errors.add(:reportable_id, :media_element_doesnt_exist) if self.reportable_type == 'MediaElement' && @media_element.nil?
  end
  
  def validate_impossible_changes
    if @report
      errors.add(:user_id, :cant_be_changed) if self.user_id != @report.user_id
      errors.add(:reportable_id, :cant_be_changed) if self.reportable_id != @report.reportable_id
      errors.add(:reportable_type, :cant_be_changed) if self.reportable_type != @report.reportable_type
      errors.add(:comment, :cant_be_changed) if self.comment != @report.comment
    end
  end
  
end
