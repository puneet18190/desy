class MediaElement < ActiveRecord::Base
  
  STAT_PRIVATE = I18n.t('status.media_elements.private')
  STAT_LINKED = I18n.t('status.media_elements.linked')
  STAT_NOT_MINE = I18n.t('status.media_elements.not_mine')
  
  self.inheritance_column = :sti_type
  
  attr_accessible :title, :description, :duration, :publication_date
  attr_reader :status
  
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :media_elements_slides
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :taggings, :as => :taggable, :dependent => :destroy
  belongs_to :user
  
  validates_presence_of :user_id, :title, :description
  validates_inclusion_of :is_public, :in => [true, false]
  validates_inclusion_of :sti_type, :in => ['Video', 'Audio', 'Image']
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :duration, :allow_nil => true, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => 255
  validate :validate_associations, :validate_publication_date, :validate_impossible_changes, :validate_duration
  
  before_validation :init_validation
  before_destroy :stop_if_public
  
  def set_status an_user_id
    return if self.new_record?
    if !self.is_public && an_user_id == self.user_id
      @status = STAT_PRIVATE
    elsif self.is_public && !self.bookmarked?(an_user_id)
      @status = STAT_NOT_MINE
    elsif self.is_public && self.bookmarked?(an_user_id)
      @status = STAT_LINKED
    else
      @status = nil
    end
  end
  
  def buttons
    return [] if !@status
    if @status == STAT_PRIVATE
      return [Buttons::PREVIEW, Buttons::EDIT, Buttons::DESTROY, Buttons::CHANGE_INFO]
    elsif @status == STAT_NOT_MINE
       return [Buttons::PREVIEW, Buttons::ADD, Buttons::REPORT]
    elsif @status == STAT_LINKED
       return [Buttons::PREVIEW, Buttons::EDIT, Buttons::REMOVE, Buttons::REPORT]
    else
      return []
    end
  end
  
  def bookmarked? an_user_id
    return false if self.new_record?
    Bookmark.where(:user_id => an_user_id, :bookmarkable_type => 'MediaElement', :bookmarkable_id => self.id).any?
  end
  
  def check_and_destroy
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_destroying)
      return false
    end
    if self.is_public
      errors.add(:base, :cant_destroy_public)
      return false
    end
    old_id = self.id
    begin
      self.destroy
    rescue Exception
      errors.add(:base, :problem_destroying)
      return false
    end
    if MediaElement.exists?(old_id)
      errors.add(:base, :problem_destroying)
      return false
    end
    true
  end
  
  private
  
  def init_validation
    @media_element = Valid.get_association self, :id
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
  end
  
  def validate_publication_date
    if self.is_public
      errors[:publication_date] << "is not a date" if self.publication_date.blank? || !self.publication_date.kind_of?(Time)
    else
      errors[:publication_date] << "must be blank if private" if !self.publication_date.blank?
    end
  end
  
  def validate_impossible_changes
    if @media_element.nil?
      errors[:is_public] << "must be false if new record" if self.is_public
    else
      errors[:sti_type] << "is not changeable" if @media_element.sti_type != self.sti_type
      if @media_element.is_public
        errors[:title] << "is not changeable for a public record" if @media_element.title != self.title
        errors[:description] << "is not changeable for a public record" if @media_element.description != self.description
        errors[:duration] << "is not changeable for a public record" if @media_element.duration != self.duration
        errors[:is_public] << "is not changeable for a public record" if !self.is_public
        errors[:publication_date] << "is not changeable for a public record" if @media_element.publication_date != self.publication_date
      else
        errors[:user_id] << "can't be changed" if @media_element.user_id != self.user_id
      end
    end
  end
  
  def validate_duration
    if self.sti_type == 'Image'
      errors[:duration] << 'must be blank for images' if !self.duration.nil?
    else
      errors[:duration] << "can't be blank for videos and audios" if self.duration.nil?
    end
  end
  
  def stop_if_public
    @media_element = Valid.get_association self, :id
    return true if @media_element.nil?
    return !@media_element.is_public
  end
  
end
