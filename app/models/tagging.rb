class Tagging < ActiveRecord::Base
  
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  validates_presence_of :tag_id, :taggable_id
  validates_numericality_of :tag_id, :taggable_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :taggable_type, :in => ['Lesson', 'MediaElement']
  validates_uniqueness_of :taggable_id, :scope => [:tag_id, :taggable_type], :if => :good_taggable_type
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation

  # FIXME: questa è da rivedere; il controllo dovrebbe essere fatto dalla validazione
  #   dell'associazione
  before_destroy :stop_destruction_if_last

  after_destroy :destroy_orphan_tags

  private

  def destroy_orphan_tags
    tag.destroy unless tag.taggings.exists?
    true
  end
  
  # def stop_destruction_if_last
  #   @tagging = Valid.get_association self, :id
  #   return true if @tagging.nil?
  #   @tagging.taggable.taggings.count > SETTINGS['min_tags_for_item']
  # end
  
  def good_taggable_type
    ['Lesson', 'MediaElement'].include? self.taggable_type
  end
  
  def init_validation
    @tagging = Valid.get_association self, :id
    @lesson = self.taggable_type == 'Lesson' ? Valid.get_association(self, :taggable_id, Lesson) : nil
    @media_element = self.taggable_type == 'MediaElement' ? Valid.get_association(self, :taggable_id, MediaElement) : nil
  end
  
  def validate_associations
    errors[:tag_id] << "doesn't exist" if !Tag.exists?(self.tag_id)
    errors[:taggable_id] << "lesson doesn't exist" if self.taggable_type == 'Lesson' && @lesson.nil?
    errors[:taggable_id] << "media element doesn't exist" if self.taggable_type == 'MediaElement' && @media_element.nil?
  end
  
  def validate_impossible_changes
    if @tagging
      errors[:tag_id] << "can't be changed" if self.tag_id != @tagging.tag_id
      errors[:taggable_id] << "can't be changed" if self.taggable_id != @tagging.taggable_id
      errors[:taggable_type] << "can't be changed" if self.taggable_type != @tagging.taggable_type
    end
  end
  
end
