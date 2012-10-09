class Lesson < ActiveRecord::Base
  
  attr_accessible :subject_id, :school_level_id, :title, :description
  
  belongs_to :user
  belongs_to :subject
  belongs_to :school_level
  belongs_to :parent, :class_name => 'Lesson', :foreign_key => :parent_id
  has_many :copies, :class_name => 'Lesson', :foreign_key => :parent_id
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :likes
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :slides
  has_many :virtual_classroom_lessons
  
  validates_presence_of :user_id, :school_level_id, :subject_id, :title, :description, :token
  validates_numericality_of :user_id, :school_level_id, :subject_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :parent_id, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_inclusion_of :is_public, :copied_not_modified, :in => [true, false]
  validates_length_of :title, :maximum => 255
  validates_length_of :token, :is => 20
  validates_uniqueness_of :parent_id, :scope => :user_id, :if => :present_parent_id
  validate :validate_associations, :validate_public, :validate_copied_not_modified_and_public, :validate_impossible_changes
  
  after_save :create_cover
  
  before_validation :init_validation, :create_token
  
  def status
    'public'
  end
  
  def buttons
    ['like', 'preview', 'add']
  end
  
  def bookmarked? an_user_id
    return false if self.new_record?
    Bookmark.where(:user_id => an_user_id, :bookmarkable_type => 'Lesson', :bookmarkable_id => self.id).any?
  end
  
  def copy an_user_id
    errors.clear
    if self.new_record? || User.where(:id => an_user_id).empty? || (!self.is_public && self.user_id != an_user_id) || (self.is_public && self.user_id != an_user_id && Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => self.id, :user_id => an_user_id).empty?)
      errors.add(:base, :problem_copying)
      return nil
    end
    if Lesson.where(:parent_id => self.id, :user_id => an_user_id).any?
      errors.add(:base, :already_copied)
      return nil
    end
    resp = nil
    ActiveRecord::Base.transaction do
      lesson = Lesson.new :subject_id => self.subject_id, :school_level_id => self.school_level_id, :title => self.title, :description => self.description
      lesson.copied_not_modified = true
      lesson.user_id = an_user_id
      lesson.parent_id = self.id
      if !lesson.save
        errors.add(:base, :problem_copying)
        raise ActiveRecord::Rollback
      end
      new_cover = Slide.where(:lesson_id => lesson.id, :position => 1).first
      if new_cover.nil?
        errors.add(:base, :problem_copying)
        raise ActiveRecord::Rollback
      end
      cover = Slide.where(:lesson_id => self.id, :position => 1).first
      cover_image = MediaElementsSlide.where(:slide_id => cover.id).first
      if cover_image
        new_cover_image = MediaElementsSlide.new
        new_cover_image.media_element_id = cover_image.media_element_id
        new_cover_image.slide_id = new_cover.id
        new_cover_image.position = 1
        if !new_cover_image.save
          errors.add(:base, :problem_copying)
          raise ActiveRecord::Rollback
        end
      end
      Slide.where('lesson_id = ? AND position > 1', self.id).order(:position).each do |s|
        new_slide = Slide.new :position => s.position, :title => s.title, :text => s.text
        new_slide.lesson_id = lesson.id
        new_slide.kind = s.kind
        if !new_slide.save
          errors.add(:base, :problem_copying)
          raise ActiveRecord::Rollback
        end
        MediaElementsSlide.where(:slide_id => s.id).each do |mes|
          new_content = MediaElementsSlide.new
          new_content.media_element_id = mes.media_element_id
          new_content.slide_id = new_slide.id
          new_content.position = mes.position
          if !new_content.save
            errors.add(:base, :problem_copying)
            raise ActiveRecord::Rollback
          end
        end
      end
      resp = lesson
    end
    resp
  end
  
  def modify
    self.copied_not_modified = false
    self.save
  end
  
  def publish
    errors.clear
    pub_date = Time.zone.now
    if self.new_record?
      errors.add(:base, :problem_publishing)
      return false
    end
    if self.is_public
      errors.add(:base, :already_published)
      return false
    end
    resp = false
    ActiveRecord::Base.transaction do
      self.is_public = true
      if !self.save
        errors.add(:base, :problem_publishing)
        raise ActiveRecord::Rollback
      end
      Slide.where(:lesson_id => self.id).each do |s|
        MediaElementsSlide.where(:slide_id => s.id).each do |mes|
          me = mes.media_element
          if !me.is_public
            me.is_public = true
            me.publication_date = pub_date
            if !me.save
              errors.add(:base, :problem_publishing)
              raise ActiveRecord::Rollback
            end
            boo = Bookmark.new
            boo.user_id = self.user_id
            boo.bookmarkable_type = 'MediaElement'
            boo.bookmarkable_id = me.id
            if !boo.save
              errors.add(:base, :problem_publishing)
              raise ActiveRecord::Rollback
            end
          end
        end
      end
      resp = true
    end
    resp
  end
  
  def unpublish
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_unpublishing)
      return false
    end
    if !self.is_public
      errors.add(:base, :already_unpublished)
      return false
    end
    resp = false
    ActiveRecord::Base.transaction do
      Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => self.id).each do |b|
        begin
          n = Notification.new
          n.user_id = b.user_id
          n.message = I18n.t("#{Notification.errors_path}.bookmark_cancelled")
          n.seen = false
          if !n.save
            errors.add(:base, :problem_unpublishing)
            raise ActiveRecord::Rollback
          end
          b.destroy
        rescue Exception
          errors.add(:base, :problem_unpublishing)
          raise ActiveRecord::Rollback
        end
      end
      self.is_public = false
      if !self.save
        errors.add(:base, :problem_unpublishing)
        raise ActiveRecord::Rollback
      end
      resp = true
    end
    resp
  end
  
  def destroy_with_notifications
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_destroying)
      return false
    end
    resp = false
    ActiveRecord::Base.transaction do
      Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => self.id).each do |b|
        n = Notification.new
        n.user_id = b.user_id
        n.message = I18n.t("#{Notification.errors_path}.bookmark_cancelled")
        n.seen = false
        if !n.save
          errors.add(:base, :problem_destroying)
          raise ActiveRecord::Rollback
        end
      end
      begin
        self.destroy
      rescue Exception
        errors.add(:base, :problem_destroying)
        raise ActiveRecord::Rollback
      end
      resp = true
    end
    resp
  end
  
  def add_slide kind
    if self.new_record? || !['text', 'image1', 'image2', 'image3', 'audio1', 'audio2', 'video1', 'video2'].include?(kind)
      errors.add(:base, :problem_adding_slide)
      return nil
    end
    resp = nil
    slide = Slide.new
    slide.kind = kind
    slide.lesson_id = self.id
    slide.position = Slide.order('position DESC').where(:lesson_id => self.id).limit(1).first.position + 1
    if slide.save
      return slide
    else
      errors.add(:base, :problem_adding_slide)
      return nil
    end
  end
  
  def add_to_virtual_classroom an_user_id
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_adding_to_virtual_classroom)
      return false
    end
    if User.where(:id => an_user_id).empty?
      errors.add(:base, :problem_adding_to_virtual_classroom)
      return false
    end
    if VirtualClassroomLesson.where(:lesson_id => self.id, :user_id => an_user_id).any?
      errors.add(:base, :lesson_already_in_virtual_classroom)
      return false
    end
    vc = VirtualClassroomLesson.new
    vc.user_id = an_user_id
    vc.lesson_id = self.id
    if !vc.save
      errors.add(:base, :lesson_not_available_for_virtual_classroom)
      return false
    end
    true
  end
  
  def remove_from_virtual_classroom an_user_id
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_removing_from_virtual_classroom)
      return false
    end
    if User.where(:id => an_user_id).empty?
      errors.add(:base, :problem_removing_from_virtual_classroom)
      return false
    end
    vc = VirtualClassroomLesson.where(:lesson_id => self.id, :user_id => an_user_id).first
    return true if vc.nil?
    if !vc.remove_from_playlist
      errors.add(:base, :problem_removing_from_virtual_classroom)
      return false
    end
    begin
      VirtualClassroomLesson.find(vc.id).destroy
    rescue
      errors.add(:base, :problem_removing_from_virtual_classroom)
      return false
    end
    true
  end
  
  private
  
  def present_parent_id
    self.parent_id
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
    errors[:subject_id] << "doesn't exist" if !Subject.exists?(self.subject_id)
    errors[:school_level_id] << "doesn't exist" if !SchoolLevel.exists?(self.school_level_id)
    errors[:parent_id] << "doesn't exist" if self.parent_id && !Lesson.exists?(self.parent_id)
    errors[:parent_id] << "can't be the lesson itself" if @lesson && self.parent_id == @lesson.id
  end
  
  def init_validation
    @lesson = Valid.get_association self, :id
  end
  
  def create_cover
    if @lesson.nil?
      slide = Slide.new :title => self.title, :position => 1
      slide.kind = 'cover'
      slide.lesson_id = self.id
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
    if @lesson
      errors[:token] << "can't be changed" if @lesson.token != self.token
      errors[:user_id] << "can't be changed" if @lesson.user_id != self.user_id
      errors[:parent_id] << "can't be changed" if self.parent_id && @lesson.parent_id != self.parent_id
    end
  end
  
  def create_token
    if !@lesson
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
