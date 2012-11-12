class Lesson < ActiveRecord::Base
  
  statuses = ::STATUSES.lessons.marshal_dump.keys
  STATUSES = Struct.new(*statuses).new(*statuses)
  
  attr_accessible :subject_id, :school_level_id, :title, :description, :tags, :tags_as_array_of_strings, :tags_as_string
  attr_reader :status, :is_reportable
  
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
  has_many :tags, :through => :taggings
  
  validates_presence_of :user_id, :school_level_id, :subject_id, :title, :description, :token
  validates_numericality_of :user_id, :school_level_id, :subject_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :parent_id, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_inclusion_of :is_public, :copied_not_modified, :in => [true, false]
  validates_length_of :title, :maximum => I18n.t('language_parameters.lesson.length_title')
  validates_length_of :description, :maximum => I18n.t('language_parameters.lesson.length_description')
  validates_length_of :token, :is => 20
  validates_length_of :tags, :minimum => CONFIG['min_tags_for_item']
  validates_uniqueness_of :parent_id, :scope => :user_id, :if => :present_parent_id
  validate :validate_associations, :validate_public, :validate_copied_not_modified_and_public, :validate_impossible_changes
  
  after_save :create_cover
  
  before_validation :init_validation, :create_token
  
  def tags_as_array_of_strings=(tags_as_array_of_strings)
    self.tags = tags_as_array_of_strings.compact.uniq.map{ |tag| Tag.find_or_initialize_by_word(tag) }
    self.tags_as_array_of_strings
  end
  
  def tags_as_array_of_strings
    tags.map(&:word)
  end
  
  def tags_as_string=(tags_as_string)
    self.tags_as_array_of_strings = tags_as_string.split(',')
    self.tags_as_string
  end
  
  def tags_as_string
    tags_as_array_of_strings.join(', ')
  end
  
  def cover
    return nil if self.new_record?
    Slide.where(:kind => 'cover', :lesson_id => self.id).first
  end
  
  def self.dashboard_emptied?(an_user_id)
    subject_ids = []
    UsersSubject.where(:user_id => an_user_id).each do |us|
      subject_ids << us.subject_id
    end
    Bookmark.joins("INNER JOIN lessons ON lessons.id = bookmarks.bookmarkable_id AND bookmarks.bookmarkable_type = 'Lesson'").where('lessons.is_public = ? AND lessons.user_id != ? AND lessons.subject_id IN (?) AND bookmarks.user_id = ?', true, an_user_id, subject_ids, an_user_id).any?
  end
  
  def set_status(an_user_id)
    return if self.new_record?
    if !self.is_public && !self.copied_not_modified && an_user_id == self.user_id
      @status = STATUSES.private
      @is_reportable = false
    elsif !self.is_public && self.copied_not_modified && an_user_id == self.user_id
      @status = STATUSES.copied
      @is_reportable = false
    elsif self.is_public && an_user_id != self.user_id && self.bookmarked?(an_user_id)
      @status = STATUSES.linked
      @is_reportable = true
    elsif self.is_public && an_user_id != self.user_id && !self.bookmarked?(an_user_id)
      @status = STATUSES.public
      @is_reportable = true
    elsif self.is_public && an_user_id == self.user_id
      @status = STATUSES.shared
      @is_reportable = false
    else
      @status = nil
      @is_reportable = nil
    end
    @in_vc = self.in_virtual_classroom?(an_user_id)
    @liked = self.liked?(an_user_id)
  end
  
  def buttons
    return [] if [@status, @in_vc, @liked, @is_reportable].include?(nil)
    case @status
    when STATUSES.private
      [Buttons::PREVIEW, Buttons::EDIT, virtual_classroom_button, Buttons::PUBLISH, Buttons::COPY, Buttons::DESTROY]
    when STATUSES.copied
      [Buttons::PREVIEW, Buttons::EDIT, Buttons::DESTROY]
    when STATUSES.linked
      [Buttons::PREVIEW, Buttons::COPY, virtual_classroom_button, like_button, Buttons::REMOVE]
    when STATUSES.public
      [Buttons::PREVIEW, Buttons::ADD, like_button]
    when STATUSES.shared
      [Buttons::PREVIEW, Buttons::EDIT, virtual_classroom_button, Buttons::UNPUBLISH, Buttons::COPY, Buttons::DESTROY]
    else
      []
    end
  end
  
  def bookmarked?(an_user_id)
    return false if self.new_record?
    Bookmark.where(:user_id => an_user_id, :bookmarkable_type => 'Lesson', :bookmarkable_id => self.id).any?
  end
  
  def copy(an_user_id)
    errors.clear
    if self.new_record? || User.where(:id => an_user_id).empty? || (!self.is_public && self.user_id != an_user_id) || (self.is_public && self.user_id != an_user_id && Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => self.id, :user_id => an_user_id).empty?)
      errors.add(:base, :problem_copying)
      return nil
    end
    if Lesson.where(:parent_id => self.id, :user_id => an_user_id).any?
      errors.add(:base, :already_copied)
      return nil
    end
    if self.copied_not_modified
      errors.add(:base, :just_copied)
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
        new_cover_image.alignment = cover_image.alignment
        new_cover_image.caption = cover_image.caption
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
          new_content.alignment = mes.alignment
          new_content.caption = mes.caption
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
  
  def add_slide(kind, position)
    errors.clear
    if self.new_record? || !['title', 'text', 'image1', 'image2', 'image3', 'image4', 'audio', 'video1', 'video2'].include?(kind)
      errors.add(:base, :problem_adding_slide)
      return nil
    end
    resp = nil
    ActiveRecord::Base.transaction do
      slide = Slide.new
      slide.kind = kind
      slide.lesson_id = self.id
      slide.position = Slide.order('position DESC').where(:lesson_id => self.id).limit(1).first.position + 1
      if slide.save
        if !slide.change_position(position)
          errors.add(:base, :problem_adding_slide)
          raise ActiveRecord::Rollback
        end
      else
        errors.add(:base, :problem_adding_slide)
        raise ActiveRecord::Rollback
      end
      resp = slide
    end
    resp
  end
  
  def add_to_virtual_classroom(an_user_id)
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
  
  def remove_from_virtual_classroom(an_user_id)
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
  
  def in_virtual_classroom?(an_user_id)
    return false if self.new_record?
    VirtualClassroomLesson.where(:user_id => an_user_id, :lesson_id => self.id).any?
  end
  
  def liked?(an_user_id)
    return false if self.new_record?
    Like.where(:user_id => an_user_id, :lesson_id => self.id).any?
  end
  
  private
  
  def virtual_classroom_button
    @in_vc ? Buttons::REMOVE_VIRTUAL_CLASSROOM : Buttons::ADD_VIRTUAL_CLASSROOM
  end
  
  def like_button
    @liked ? Buttons::DISLIKE : Buttons::LIKE
  end
  
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
