class Tagging < ActiveRecord::Base
  
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  validates_presence_of :tag_id, :taggable_id
  validates_numericality_of :tag_id, :taggable_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :taggable_type, :in => ['Lesson', 'MediaElement']
  validates_uniqueness_of :taggable_id, :scope => [:tag_id, :taggable_type], :if => :good_taggable_type
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation
  
  private
  
  def good_taggable_type
    ['Lesson', 'MediaElement'].include? self.taggable_type
  end
  
  def init_validation
    @tagging = Valid.get_association self, :id
  end
  
  def validate_associations
    errors[:tag_id] << "doesn't exist" if !Tag.exists?(self.tag_id)
    errors[:taggable_id] << "lesson doesn't exist" if self.taggable_type == 'Lesson' && !Lesson.exists?(self.taggable_id)
    errors[:taggable_id] << "media element doesn't exist" if self.taggable_type == 'MediaElement' && !MediaElement.exists?(self.taggable_id)
  end
  
  def validate_impossible_changes
    if @tagging
      errors[:tag_id] << "can't be changed" if self.tag_id != @tagging.tag_id
      errors[:taggable_id] << "can't be changed" if self.taggable_id != @tagging.taggable_id
      errors[:taggable_type] << "can't be changed" if self.taggable_type != @tagging.taggable_type
    end
  end
  
end
