class Bookmark < ActiveRecord::Base
  
  belongs_to :bookmarkable, :polymorphic => true
  belongs_to :user
  
  validates_presence_of :user_id, :bookmarkable_id
  validates_numericality_of :user_id, :bookmarkable_id, :only_integer => true, :greater_than => 0
  validates_inclusion_of :bookmarkable_type, :in => ['Lesson', 'MediaElement']
  validates_uniqueness_of :bookmarkable_id, :scope => [:user_id, :bookmarkable_type]
  validate :validate_associations, :validate_availability
  
  before_validation :init_validation
  before_destroy :destroy_virtual_classroom
  
  private
  
  def init_validation
    @bookmark = Valid.get_association self, :id
    @lesson = self.bookmarkable_type == 'Lesson' ? Valid.get_association(self, :bookmarkable_id, Lesson) : nil
    @media_element = self.bookmarkable_type == 'MediaElement' ? Valid.get_association(self, :bookmarkable_id, MediaElement) : nil
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
    errors[:bookmarkable_id] << "lesson doesn't exist" if self.bookmarkable_type == 'Lesson' && !Lesson.exists?(self.bookmarkable_id)
    errors[:bookmarkable_id] << "media element doesn't exist" if self.bookmarkable_type == 'MediaElement' && !MediaElement.exists?(self.bookmarkable_id)
  end
  
  def validate_availability
    errors[:bookmarkable_id] << "lesson not available for bookmarks" if @lesson && (@lesson.user_id == self.user_id || !@lesson.is_public)
    errors[:bookmarkable_id] << "media element not available for bookmarks" if @media_element && !@media_element.is_public
  end
  
  def destroy_virtual_classroom
    # This model must implement also a cascade destruction for the table virtual_classroom_lessons (13), inside the ruby code.
  end

  
#user_id: integer
#bookmarkable_id: integer
#bookmarkable_type:

  
end
