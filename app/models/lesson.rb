class Lesson < ActiveRecord::Base
  
  attr_accessible :subject_id, :school_level_id, :title, :description
  
  belongs_to :user
  belongs_to :subject
  belongs_to :school_level
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :likes
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :slides
  has_many :virtual_classroom_lessons
  
  validates_presence_of :user_id, :school_level_id, :subject_id, :title, :description
  validates_numericality_of :user_id, :school_level_id, :subject_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :parent_id, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_inclusion_of :is_public, :copied_not_modified, :in => [true, false]
  validates_length_of :title, :token, :maximum => 255
  validates_uniqueness_of :parent_id, :scope => :user_id, :if => self.parent_id
  validate :validate_public, :validate_copied_not_modified_and_public, :validate_impossible_changes
  
  after_save :create_cover
  
  before_validation :init_validation, :create_token
  
  private
  
  def init_validation
    @lesson = self.new_record? ? nil : Lesson.where(:id => self.id).first
  end
  
  def create_cover
    if @lesson.nil?
      slide = Slide.new :type => 'cover', :lesson_id => self.id, :title => self.title, :position => 1
      slide.save
    end
  end
  
  def validate_public
    errors[:is_public] << "can't be true for new records" if @lesson.nil? && self.is_public
  end
  
  def validate_copied_not_modified_and_public
    errors[:copied_not_modified] << "can't be true if public" if self.is_public && self.copied_not_modified
  end
  
  def validate_impossible_changes
    if !@lesson.nil?
      errors[:token] << "can't be changed" if @lesson.token != self.token
      errors[:user_id] << "can't be changed" if @lesson.user_id != self.user_id
      errors[:parent_id] << "can't be changed" if self.parent_id && @lesson.parent_id != self.parent_id
    end
  end
  
  def create_token
    if self.new_record?
      tok = ''
      i = 0
      while i < 20
        tok = "#{tok}#{rand(10)}"
        i += 1
      end
      self.token = tok
    end
  end
  
end
