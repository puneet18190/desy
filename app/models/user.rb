class User < ActiveRecord::Base
  
  MY_MEDIA_ELEMENTS_QUERY = '(user_id = ? AND is_public = ?) OR EXISTS (SELECT * FROM bookmarks WHERE bookmarks.bookmarkable_type = ? AND bookmarks.bookmarkable_id = media_elements.id AND bookmarks.user_id = ?)'
  
  attr_accessible :name, :surname, :school_level_id, :school, :location_id
  
  has_many :bookmarks
  has_many :notifications
  has_many :likes
  has_many :lessons
  has_many :media_elements
  has_many :reports
  has_many :users_subjects
  has_many :virtual_classroom_lessons
  belongs_to :school_level
  belongs_to :location
  
  validates_presence_of :email, :name, :surname, :school_level_id, :school, :location_id
  validates_numericality_of :school_level_id, :location_id, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :email
  validates_length_of :name, :surname, :email, :school, :maximum => 255
  validate :validate_associations, :validate_email, :validate_email_not_changed
  
  before_validation :init_validation
  
  def full_name
    "#{self.name} #{self.surname}"
  end
  
  def report_lesson(lesson_id, msg)
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_reporting)
      return false
    end
    r = Report.new
    r.user_id = self.id
    r.reportable_type = 'Lesson'
    r.reportable_id = lesson_id
    r.comment = msg
    if !r.save
      if r.errors.messages.has_key?(:reportable_id) && r.errors.messages[:reportable_id].first == "has already been taken"
        errors.add(:base, :lesson_already_reported)
      else
        errors.add(:base, :problem_reporting)
      end
      return false
    end
    true
  end
  
  def report_media_element(media_element_id, msg)
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_reporting)
      return false
    end
    r = Report.new
    r.user_id = self.id
    r.reportable_type = 'MediaElement'
    r.reportable_id = media_element_id
    r.comment = msg
    if !r.save
      if r.errors.messages.has_key?(:reportable_id) && r.errors.messages[:reportable_id].first == "has already been taken"
        errors.add(:base, :media_element_already_reported)
      else
        errors.add(:base, :problem_reporting)
      end
      return false
    end
    true
  end
  
  def like(lesson_id)
    return false if self.new_record? || !Lesson.exists?(lesson_id)
    return true if Like.where(:lesson_id => lesson_id, :user_id => self.id).any?
    l = Like.new
    l.user_id = self.id
    l.lesson_id = lesson_id
    return l.save
  end
  
  def dislike(lesson_id)
    return false if self.new_record? || !Lesson.exists?(lesson_id)
    like = Like.where(:lesson_id => lesson_id, :user_id => self.id).first
    return true if like.nil?
    like.destroy
    return Like.where(:lesson_id => lesson_id, :user_id => self.id).empty?
  end
  
  def own_media_elements(page, per_page, filter=nil)
    offset = (page - 1) * per_page
    filter = Filters::ALL_MEDIA_ELEMENTS if filter.nil? || !Filters::MEDIA_ELEMENTS_SET.include?(filter)
    param1 = MY_MEDIA_ELEMENTS_QUERY
    param2 = self.id
    param2b = false
    param3 = 'MediaElement'
    param4 = self.id
    my_order = 'updated_at DESC'
    resp = []
    case filter
      when Filters::ALL_MEDIA_ELEMENTS
        last_page = MediaElement.where(param1, param2, param2b, param3, param4).order(my_order).offset(offset + per_page).empty?
        resp = MediaElement.where(param1, param2, param2b, param3, param4).order(my_order).limit(per_page).offset(offset)
      when Filters::VIDEO
        last_page = Video.where(param1, param2, param2b, param3, param4).order(my_order).offset(offset + per_page).empty?
        resp = Video.where(param1, param2, param2b, param3, param4).order(my_order).limit(per_page).offset(offset)
      when Filters::AUDIO
        last_page = Audio.where(param1, param2, param2b, param3, param4).order(my_order).offset(offset + per_page).empty?
        resp = Audio.where(param1, param2, param2b, param3, param4).order(my_order).limit(per_page).offset(offset)
      when Filters::IMAGE
        last_page = Image.where(param1, param2, param2b, param3, param4).order(my_order).offset(offset + per_page).empty?
        resp = Image.where(param1, param2, param2b, param3, param4).order(my_order).limit(per_page).offset(offset)
    end
    return {:last_page => last_page, :content => resp}
  end
  
  def own_lessons(page, per_page, filter=nil)
    offset = (page - 1) * per_page
    filter = Filters::ALL_LESSONS if filter.nil? || !Filters::LESSONS_SET.include?(filter)
    resp = []
    my_order = 'updated_at DESC'
    case filter
      when Filters::ALL_LESSONS
        param1 = self.id
        last_page = MyLessonsView.where('lesson_user_id = ? OR bookmark_user_id = ?', param1, param1).offset(offset + per_page).empty?
        resp = MyLessonsView.where('lesson_user_id = ? OR bookmark_user_id = ?', param1, param1).limit(per_page).offset(offset)
      when Filters::PRIVATE
        filtered_query = "is_public =  ? AND user_id = ?"
        param2 = false
        param3 = self.id
        last_page = Lesson.where(filtered_query, param2, param3).order(my_order).offset(offset + per_page).empty?
        resp = Lesson.where(filtered_query, param2, param3).order(my_order).limit(per_page).offset(offset)
      when Filters::PUBLIC
        param1 = true
        param2 = self.id
        last_page = MyLessonsView.where('is_public = ? AND (lesson_user_id = ? OR bookmark_user_id = ?)', param1, param2, param2).offset(offset + per_page).empty?
        resp = MyLessonsView.where('is_public = ? AND (lesson_user_id = ? OR bookmark_user_id = ?)', param1, param2, param2).limit(per_page).offset(offset)
      when Filters::LINKED
        param1 = self.id
        last_page = MyLessonsView.where('bookmark_user_id = ?', param1).offset(offset + per_page).empty?
        resp = MyLessonsView.where('bookmark_user_id = ?', param1).limit(per_page).offset(offset)
      when Filters::ONLY_MINE
        last_page = Lesson.where(:user_id => self.id).order(my_order).offset(offset + per_page).empty?
        resp = Lesson.where(:user_id => self.id).order(my_order).limit(per_page).offset(offset)
      when Filters::COPIED
        last_page = Lesson.where(:user_id => self.id, :copied_not_modified => true).order(my_order).offset(offset + per_page).empty?
        resp = Lesson.where(:user_id => self.id, :copied_not_modified => true).order(my_order).limit(per_page).offset(offset)
    end
    return {:last_page => last_page, :content => resp}
  end
  
  def suggested_lessons(n)
    subject_ids = []
    UsersSubject.where(:user_id => self.id).each do |us|
      subject_ids << us.subject_id
    end
    Lesson.where('is_public = ? AND user_id != ? AND subject_id IN (?) AND NOT EXISTS (SELECT * FROM bookmarks WHERE bookmarks.bookmarkable_type = ? AND bookmarks.bookmarkable_id = lessons.id AND bookmarks.user_id = ?)', true, self.id, subject_ids, 'Lesson', self.id).order('updated_at DESC').limit(n)
  end
  
  def suggested_media_elements(n)
    MediaElement.where('is_public = ? AND user_id != ? AND NOT EXISTS (SELECT * FROM bookmarks WHERE bookmarks.bookmarkable_type = ? AND bookmarks.bookmarkable_id = media_elements.id AND bookmarks.user_id = ?)', true, self.id, 'MediaElement', self.id).order('publication_date DESC').limit(n)
  end
  
  def bookmark(type, target_id)
    return false if self.new_record?
    b = Bookmark.new
    b.bookmarkable_type = type
    b.user_id = self.id
    b.bookmarkable_id = target_id
    b.save
  end
  
  def playlist
    return [] if self.new_record?
    VirtualClassroomLesson.where('user_id = ? AND position IS NOT NULL', self.id).order(:position)
  end
  
  def create_lesson(title, description, subject_id)
    return nil if self.new_record?
    return nil if UsersSubject.where(:user_id => self.id, :subject_id => subject_id).empty?
    lesson = Lesson.new :subject_id => subject_id, :school_level_id => self.school_level_id, :title => title, :description => description
    lesson.copied_not_modified = false
    lesson.user_id = self.id
    return lesson.save ? lesson : nil
  end
  
  def self.create_user(an_email, a_name, a_surname, a_school, a_school_level_id, a_location_id, subject_ids)
    return nil if subject_ids.class != Array || subject_ids.empty?
    resp = User.new :name => a_name, :surname => a_surname, :school_level_id => a_school_level_id, :school => a_school, :location_id => a_location_id
    resp.email = an_email
    ActiveRecord::Base.transaction do
      if !resp.save
        resp = nil
        raise ActiveRecord::Rollback
      end
      subject_ids.each do |s|
        us = UsersSubject.new
        us.user_id = resp.id
        us.subject_id = s
        if !us.save
          resp = nil
          raise ActiveRecord::Rollback
        end
      end
    end
    resp
  end
  
  def edit_fields(a_name, a_surname, a_school, a_school_level_id, a_location_id, subject_ids)
    errors.clear
    if subject_ids.class != Array || subject_ids.empty?
      errors.add(:base, :missing_subjects)
      return false
    end
    if self.new_record?
      errors.add(:base, :problems_updating)
      return false
    end
    resp = false
    self.name = a_name
    self.surname = a_surname
    self.school_level_id = a_school_level_id
    self.school = a_school
    self.location_id = a_location_id
    ActiveRecord::Base.transaction do
      if !self.save
        errors.add(:base, :problems_updating)
        raise ActiveRecord::Rollback
      end
      begin
        UsersSubject.where(:user_id => self.id).each do |us|
          if !subject_ids.include?(us.subject_id)
            us.destroy
            subject_ids.delete us.subject_id
          end
        end
        subject_ids.each do |s|
          if UsersSubject.where(:user_id => self.id, :subject_id => s).empty?
            us = UsersSubject.new
            us.user_id = self.id
            us.subject_id = s
            if !us.save
              raise ActiveRecord::Rollback
              errors.add(:base, :problems_updating)
            end
          end
        end
        if !self.save
          raise ActiveRecord::Rollback
          errors.add(:base, :problems_updating)
        end
      rescue ActiveRecord::InvalidForeignKey
        errors.add(:base, :problems_updating)
        raise ActiveRecord::Rollback
      end
      resp = true
    end
    resp
  end
  
  def destroy_with_dependencies
    if self.new_record?
      errors.add(:base, :problems_destroying)
      return false
    end
    resp = false
    ActiveRecord::Base.transaction do
      begin
        Lesson.where(:user_id => self.id).each do |l|
          if !l.destroy_with_notifications
            errors.add(:base, :problems_destroying)
            raise ActiveRecord::Rollback
          end
        end
        UsersSubject.where(:user_id => self.id).each do |us|
          us.destroy
        end
        MediaElement.where(:user_id => self.id).each do |me|
          if me.is_public
            me.user_id = User.find_by_email(CONFIG['admin_email']).id
            if !me.save
              errors.add(:base, :problems_destroying)
              raise ActiveRecord::Rollback
            end
          else
            me.destroy
          end
        end
        Bookmark.where(:user_id => self.id).each do |b|
          b.destroy
        end
        Notification.where(:user_id => self.id).each do |n|
          n.destroy
        end
        Like.where(:user_id => self.id).each do |l|
          l.destroy
        end
        Report.where(:user_id => self.id).each do |r|
          r.destroy
        end
        self.destroy
      rescue ActiveRecord::InvalidForeignKey
        errors.add(:base, :problems_destroying)
        raise ActiveRecord::Rollback
      end
      resp = true
    end
    resp
  end
  
  private
  
  def init_validation
    @user = Valid.get_association self, :id
  end
  
  def validate_associations
    errors[:location_id] << "doesn't exist" if !Location.exists?(self.location_id)
    errors[:school_level_id] << "doesn't exist" if !SchoolLevel.exists?(self.school_level_id)
  end
  
  def validate_email
    return if self.email.blank?
    flag = false
    x = self.email.split('@')
    if x.length == 2
      x = x[1].split('.')
      if x.length > 1
        flag = true if x.last.length < 2
      else
        flag = true
      end
    else
      flag = true
    end
    errors[:email] << 'is not in the correct format' if flag
  end
  
  def validate_email_not_changed
    return if @user.nil?
    errors[:email] << "can't change after having been initialized" if @user.email != self.email
  end
  
end
