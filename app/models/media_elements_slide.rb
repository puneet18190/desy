class MediaElementsSlide < ActiveRecord::Base
  
  attr_accessible :position
  
  belongs_to :media_element
  belongs_to :slide
  
  validates_presence_of :media_element_id, :slide_id
  validates_numericality_of :media_element_id, :slide_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :alignment, :only_integer => true, :allow_nil => true
  validates_inclusion_of :position, :in => [1, 2, 3, 4]
  validates_uniqueness_of :position, :scope => [:media_element_id, :slide_id]
  validate :validate_associations, :validate_type_in_slide, :validate_position, :validate_media_element, :validate_impossible_changes, :validate_image_properties
  
  before_validation :init_validation
  
  private
  
  def init_validation
    @media_elements_slide = Valid.get_association self, :id
    @slide = Valid.get_association self, :slide_id
    @media_element = Valid.get_association self, :media_element_id
  end
  
  def validate_image_properties
    errors[:alignment] << 'must be null if the element is not an image' if @media_element && !@media_element.image? && !self.alignment.nil?
    errors[:alignment] << "can't be null if the element is an image" if @media_element && @media_element.image? && self.alignment.nil?
    errors[:caption] << 'must be null if the element is not an image' if @media_element && !@media_element.image? && !self.caption.blank?
  end
  
  def validate_associations
    errors[:media_element_id] << "doesn't exist" if @media_element.nil?
    errors[:slide_id] << "doesn't exist" if @slide.nil?
  end
  
  def validate_type_in_slide
    errors[:media_element_id] << 'is not compatible with the kind of slide' if @media_element && @slide && @slide.accepted_media_element_sti_type != @media_element.sti_type
  end
  
  def validate_position
    errors[:position] << "can't have two media elements if slide is not of the kinds 'image2', 'image4'" if @media_element && @slide && self.position == 2 && ![Slide::IMAGE2, Slide::IMAGE4].include?(@slide.kind)
    errors[:position] << "can't have more than two media elements if slide is not of the kind 'image4'" if @media_element && @slide && [3, 4].include?(self.position) && @slide.kind != Slide::IMAGE4
  end
  
  def validate_media_element
    errors[:media_element_id] << "is not available" if @media_element && @slide && !@media_element.is_public && @media_element.user_id != @slide.lesson.user_id
  end
  
  def validate_impossible_changes
    if @media_elements_slide
      errors[:slide_id] << "can't be changed" if @media_elements_slide.slide_id != self.slide_id
    end
  end
  
end
