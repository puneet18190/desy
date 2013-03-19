class Lesson < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  extend LessonsMediaElementsShared
  
  attr_accessible :subject_id, :school_level_id, :title, :description
  attr_reader :is_reportable
  attr_accessor :skip_public_validations, :skip_cover_creation
  
  serialize :metadata, OpenStruct
  
  belongs_to :user
  belongs_to :subject
  belongs_to :school_level
  belongs_to :parent, :class_name => 'Lesson', :foreign_key => :parent_id
  has_many :copies, :class_name => 'Lesson', :foreign_key => :parent_id
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :likes
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :taggings, :as => :taggable
  has_many :slides
  has_many :media_elements_slides, through: :slides
  has_many :media_elements, through: :media_elements_slides
  has_many :virtual_classroom_lessons
  
  validates_presence_of :user_id, :school_level_id, :subject_id, :title, :description
  validates_numericality_of :user_id, :school_level_id, :subject_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :parent_id, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_inclusion_of :is_public, :copied_not_modified, :notified, :in => [true, false]
  validates_length_of :title, :maximum => I18n.t('language_parameters.lesson.length_title')
  validates_length_of :description, :maximum => I18n.t('language_parameters.lesson.length_description')
  validates_uniqueness_of :parent_id, :scope => :user_id, :if => :present_parent_id
  validate :validate_associations, :validate_public, :validate_copied_not_modified_and_public, :validate_impossible_changes, :validate_tags_length
  
  before_validation :init_validation
  before_create :initialize_metadata, :create_token
  after_save :create_or_update_cover, :update_or_create_tags
  before_destroy :destroy_taggings
  
  # SELECT "lessons".* FROM "lessons" LEFT JOIN bookmarks ON bookmarks.bookmarkable_id = lessons.id AND bookmarks.bookmarkable_type = 'Lesson' AND bookmarks.user_id = 1 ORDER BY COALESCE(bookmarks.created_at, lessons.updated_at) DESC
  scope :of, ->(user_or_user_id) do
    user_id = user_or_user_id.instance_of?(User) ? user_or_user_id.id : user_or_user_id
    joins(sanitize_sql ["LEFT JOIN bookmarks ON 
                         bookmarks.bookmarkable_id = lessons.id AND 
                         bookmarks.bookmarkable_type = 'Lesson' AND 
                         bookmarks.user_id = %i", user_id] ).
    where('bookmarks.user_id IS NOT NULL OR lessons.user_id = ?', user_id).
    order('COALESCE(bookmarks.created_at, lessons.updated_at) DESC')
  end
  
  def initialize_metadata
    self.metadata.available_video = true
    self.metadata.available_audio = true
  end
  
  def notify_changes(msg)
    Bookmark.where('bookmarkable_type = ? AND bookmarkable_id = ? AND created_at < ?', 'Lesson', self.id, self.updated_at).each do |bo|
      if msg.blank?
        Notification.send_to bo.user_id, I18n.t('notifications.lessons.modified', :user_name => self.user.full_name, :lesson_title => self.title, :link => lesson_viewer_path(self.id), :message => I18n.t('lessons.notify_modifications.empty_message'))
      else
        Notification.send_to bo.user_id, I18n.t('notifications.lessons.modified', :user_name => self.user.full_name, :lesson_title => self.title, :link => lesson_viewer_path(self.id), :message => msg[0, I18n.t('language_parameters.notification.message_length_for_public_lesson_modification')])
      end
    end
    self.notified = true
    self.save
  end
  
  def dont_notify_changes
    self.notified = true
    self.save
  end
  
  def not_notified?
    return false if self.status.nil?
    !self.notified && Bookmark.where('bookmarkable_type = ? AND bookmarkable_id = ? AND created_at < ?', 'Lesson', self.id, self.updated_at).any?
  end
  
  def available?(type = nil)
    case type = type.to_s.downcase
    when 'video', 'audio'
      metadata.send :"available_#{type}"
    else
      metadata.available_video && metadata.available_audio
    end
  end
  
  def available!(type, value = true)
    metadata.send :"available_#{type.to_s.downcase}=", !!value
    update_attribute(:metadata, metadata)
  end
  
  def tags
    self.new_record? ? '' : Tag.get_friendly_tags(self.id, 'Lesson')
  end
  
  def tags=(tags)
    @tags = 
      case tags
      when String
        tags
      when Array
        tags.map(&:to_s).join(',')
      end
    @tags
  end
  
  def cover
    return nil if self.new_record?
    Slide.where(:kind => Slide::COVER, :lesson_id => self.id).first
  end
  
  def self.dashboard_emptied?(an_user_id)
    subject_ids = []
    UsersSubject.where(:user_id => an_user_id).each do |us|
      subject_ids << us.subject_id
    end
    Bookmark.joins("INNER JOIN lessons ON lessons.id = bookmarks.bookmarkable_id AND bookmarks.bookmarkable_type = 'Lesson'").where('lessons.is_public = ? AND lessons.user_id != ? AND lessons.subject_id IN (?) AND bookmarks.user_id = ?', true, an_user_id, subject_ids, an_user_id).any?
  end
  
  def status(with_captions=false)
    @status.nil? ? nil : (with_captions ? Lesson.status(@status) : @status)
  end
  
  def set_status(an_user_id)
    return if self.new_record?
    if !self.is_public && !self.copied_not_modified && an_user_id == self.user_id
      @status = Statuses::PRIVATE
      @is_reportable = false
    elsif !self.is_public && self.copied_not_modified && an_user_id == self.user_id
      @status = Statuses::COPIED
      @is_reportable = false
    elsif self.is_public && an_user_id != self.user_id && self.bookmarked?(an_user_id)
      @status = Statuses::LINKED
      @is_reportable = true
    elsif self.is_public && an_user_id != self.user_id && !self.bookmarked?(an_user_id)
      @status = Statuses::PUBLIC
      @is_reportable = true
    elsif self.is_public && an_user_id == self.user_id
      @status = Statuses::SHARED
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
    when Statuses::PRIVATE
      [Buttons::PREVIEW, Buttons::EDIT, virtual_classroom_button, Buttons::PUBLISH, Buttons::COPY, Buttons::DESTROY]
    when Statuses::COPIED
      [Buttons::PREVIEW, Buttons::EDIT, Buttons::DESTROY]
    when Statuses::LINKED
      [Buttons::PREVIEW, Buttons::COPY, virtual_classroom_button, like_button, Buttons::REMOVE]
    when Statuses::PUBLIC
      [Buttons::PREVIEW, Buttons::ADD, like_button]
    when Statuses::SHARED
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
      lesson.tags = self.tags
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
  
  def visive_tags
    Tagging.visive_tags(self.tags)
  end
  
  def modified
    self.copied_not_modified = false
  end
  
  def modify
    self.copied_not_modified = false
    self.notified = false
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
          if !Notification.send_to b.user_id, I18n.t('notifications.lessons.unpublished', :user_name => self.user.full_name, :lesson_title => self.title)
            errors.add(:base, :problem_unpublishing)
            raise ActiveRecord::Rollback
          end
          b.destroy
        rescue StandardError
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
        if !Notification.send_to b.user_id, I18n.t('notifications.lessons.destroyed', :user_name => self.user.full_name, :lesson_title => self.title)
          errors.add(:base, :problem_destroying)
          raise ActiveRecord::Rollback
        end
      end
      begin
        self.destroy
      rescue StandardError
        errors.add(:base, :problem_destroying)
        raise ActiveRecord::Rollback
      end
      resp = true
    end
    resp
  end
  
  def add_slide(kind, position)
    if self.new_record? || !Slide::KINDS_WITHOUT_COVER.include?(kind)
      return nil
    end
    resp = nil
    ActiveRecord::Base.transaction do
      slide = Slide.new
      slide.kind = kind
      slide.lesson_id = self.id
      slide.position = Slide.order('position DESC').where(:lesson_id => self.id).limit(1).first.position + 1
      raise ActiveRecord::Rollback if !slide.save || !slide.change_position(position) || !self.modify
      resp = slide
    end
    resp
  end
  
  def reached_the_maximum_of_slides?
    Slide.where(:lesson_id => self.id).count == SETTINGS['max_number_slides_in_a_lesson']
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
  
  def validate_tags_length
    errors[:tags] << "are not enough" if @inner_tags.length < SETTINGS['min_tags_for_item']
  end
  
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
    errors[:user_id] << "doesn't exist" if @user.nil?
    errors[:subject_id] << "doesn't exist" if @subject.nil?
    errors[:school_level_id] << "doesn't exist" if @school_level.nil?
    errors[:parent_id] << "doesn't exist" if self.parent_id && @parent.nil?
    errors[:parent_id] << "can't be the lesson itself" if @lesson && self.parent_id == @lesson.id
  end
  
  def update_or_create_tags
    return true unless @inner_tags
    words = []
    @inner_tags.each do |t|
      raise ActiveRecord::Rollback if t.new_record? && !t.save
      words << t.id
      tagging = Tagging.where(:taggable_id => self.id, :taggable_type => 'Lesson', :tag_id => t.id).first
      if tagging.nil?
        tagging = Tagging.new
        tagging.taggable_id = self.id
        tagging.taggable_type = 'Lesson'
        tagging.tag_id = t.id
        raise ActiveRecord::Rollback if !tagging.save
      end
    end
    Tagging.where(:taggable_type => 'Lesson', :taggable_id => self.id).each do |t|
      t.destroy if !words.include?(t.tag_id)
    end
  end
  
  def init_validation
    @lesson = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
    @subject = Valid.get_association self, :subject_id
    @school_level = Valid.get_association self, :school_level_id
    @parent = Valid.get_association self, :parent_id, Lesson
    @title_changed = (@lesson && @lesson.title != self.title)
    if @tags.blank?
      @inner_tags = Tag.get_tags_for_item(self.id, 'Lesson')
    else
      resp_tags = []
      prev_tags = []
      @tags.split(',').each do |t|
        if !t.blank?
          t = t.to_s.strip.mb_chars.downcase.to_s
          if !prev_tags.include? t
            tag = Tag.find_by_word t
            tag = Tag.new(:word => t) if tag.nil?
            resp_tags << tag if tag.valid?
          end
          prev_tags << t
        end
      end
      @inner_tags = resp_tags
    end
  end
  
  def create_or_update_cover
    if @lesson.nil?
      return true if skip_cover_creation
      slide = Slide.new :title => self.title, :position => 1
      slide.kind = Slide::COVER
      slide.lesson_id = self.id
      slide.save
    elsif @title_changed
      my_cover = self.cover
      my_cover.title = self.title
      my_cover.save
    end
  end
  
  def validate_public
    errors[:is_public] << "can't be true for new records" if @lesson.nil? && self.is_public && !self.skip_public_validations
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
    self.token = SecureRandom.urlsafe_base64(16)
    true
  end
  
  def destroy_taggings
    Tagging.where(:taggable_type => 'Lesson', :taggable_id => self.id).each do |tagging|
      tagging.destroyable = true
      tagging.destroy
    end
  end
  
  def self.test
    l = User.admin.create_lesson('test title', 'test description', 1, "asd, o, mar, rio, mare, test")
    l = find l.id
    _d l
    l.destroy
  end
  
end
