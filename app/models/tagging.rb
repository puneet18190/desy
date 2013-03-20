class Tagging < ActiveRecord::Base
  
  attr_writer :not_orphans
  
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  validates_presence_of :tag_id, :taggable_id
  validates_numericality_of :tag_id, :taggable_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :taggable_type, :in => ['Lesson', 'MediaElement']
  validates_uniqueness_of :taggable_id, :scope => [:tag_id, :taggable_type], :if => :good_taggable_type
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation
  after_destroy :destroy_orphan_tags
  
  def self.visive_tags(tags)
    tags[1, tags.length].chop.gsub(',', ', ')
  end
  
  private
  
  def destroy_orphan_tags
    return true if @not_orphans
    tag.destroy if !tag.taggings.exists?
    true
  end
  
  def good_taggable_type
    ['Lesson', 'MediaElement'].include? self.taggable_type
  end
  
  def init_validation
    @tagging = Valid.get_association self, :id
    @lesson = self.taggable_type == 'Lesson' ? Valid.get_association(self, :taggable_id, Lesson) : nil
    @media_element = self.taggable_type == 'MediaElement' ? Valid.get_association(self, :taggable_id, MediaElement) : nil
  end
  
  def validate_associations
    errors.add(:tag_id, :doesnt_exist) if !Tag.exists?(self.tag_id)
    errors.add(:taggable_id, :lesson_doesnt_exist) if self.taggable_type == 'Lesson' && @lesson.nil?
    errors.add(:taggable_id, :media_element_doesnt_exist) if self.taggable_type == 'MediaElement' && @media_element.nil?
  end
  
  def validate_impossible_changes
    if @tagging
      errors.add(:tag_id, :cant_be_changed) if self.tag_id != @tagging.tag_id
      errors.add(:taggable_id, :cant_be_changed) if self.taggable_id != @tagging.taggable_id
      errors.add(:taggable_type, :cant_be_changed) if self.taggable_type != @tagging.taggable_type
    end
  end
  
end
