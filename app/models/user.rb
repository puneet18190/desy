class User < ActiveRecord::Base
  
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
  
  def search_media_elements(word, page, for_page, order=nil, filter=nil)
    page = 1 if page.class != Fixnum || page < 0
    for_page = 1 if for_page.class != Fixnum || for_page < 0
    filter = Filters::ALL_MEDIA_ELEMENTS if filter.nil? || !Filters::MEDIA_ELEMENTS_SEARCH_SET.include?(filter)
    order = SearchOrders::UPDATED_AT if order.nil? || !SearchOrders::MEDIA_ELEMENTS_SET.include?(order)
    offset = (page - 1) * for_page
    if word.blank?
      search_media_elements_without_tag(offset, for_page, filter, order)
    elsif word.class == Fixnum
      search_media_elements_with_tag(word, offset, for_page, filter, order)
    else
      word = word.to_s
      search_media_elements_with_tag(word, offset, for_page, filter, order)
    end
  end
  
  def search_lessons(word, page, for_page, order=nil, filter=nil, subject_id=nil)
    page = 1 if page.class != Fixnum || page < 0
    for_page = 1 if for_page.class != Fixnum || for_page < 0
    subject_id = nil if ![NilClass, Fixnum].include?(subject_id.class)
    filter = Filters::ALL_LESSONS if filter.nil? || !Filters::LESSONS_SEARCH_SET.include?(filter)
    order = SearchOrders::UPDATED_AT if order.nil? || !SearchOrders::LESSONS_SET.include?(order)
    offset = (page - 1) * for_page
    if word.blank?
      search_lessons_without_tag(offset, for_page, filter, subject_id, order)
    elsif word.class == Fixnum
      search_lessons_with_chosen_tag(word, offset, for_page, filter, subject_id, order)
    else
      word = word.to_s
      search_lessons_with_tag(word, offset, for_page, filter, subject_id, order)
    end
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
    page = 1 if page.class != Fixnum || page < 0
    for_page = 1 if for_page.class != Fixnum || for_page < 0
    offset = (page - 1) * per_page
    filter = Filters::ALL_MEDIA_ELEMENTS if filter.nil? || !Filters::MEDIA_ELEMENTS_SET.include?(filter)
    param1 = self.id
    param2 = false
    resp = []
    last_page = false
    item_count = 0
    case filter
      when Filters::ALL_MEDIA_ELEMENTS
        item_count = MyMediaElementsView.where('(media_element_user_id = ? AND is_public = ?) OR bookmark_user_id = ?', param1, param2, param1).count
        last_page = (item_count <= offset + per_page)
        MyMediaElementsView.where('(media_element_user_id = ? AND is_public = ?) OR bookmark_user_id = ?', param1, param2, param1).limit(per_page).offset(offset).each do |me|
          media_element = MediaElement.find_by_id me.id
          media_element.set_status self.id
          resp << media_element
        end
      when Filters::VIDEO
        param0 = 'Video'
        item_count = MyMediaElementsView.where('sti_type = ? AND ((media_element_user_id = ? AND is_public = ?) OR bookmark_user_id = ?)', param0, param1, param2, param1).count
        last_page = (item_count <= offset + per_page)
        MyMediaElementsView.where('sti_type = ? AND ((media_element_user_id = ? AND is_public = ?) OR bookmark_user_id = ?)', param0, param1, param2, param1).limit(per_page).offset(offset).each do |me|
          media_element = MediaElement.find_by_id me.id
          media_element.set_status self.id
          resp << media_element
        end
      when Filters::AUDIO
        param0 = 'Audio'
        item_count = MyMediaElementsView.where('sti_type = ? AND ((media_element_user_id = ? AND is_public = ?) OR bookmark_user_id = ?)', param0, param1, param2, param1).count
        last_page = (item_count <= offset + per_page)
        MyMediaElementsView.where('sti_type = ? AND ((media_element_user_id = ? AND is_public = ?) OR bookmark_user_id = ?)', param0, param1, param2, param1).limit(per_page).offset(offset).each do |me|
          media_element = MediaElement.find_by_id me.id
          media_element.set_status self.id
          resp << media_element
        end
      when Filters::IMAGE
        param0 = 'Image'
        item_count = MyMediaElementsView.where('sti_type = ? AND ((media_element_user_id = ? AND is_public = ?) OR bookmark_user_id = ?)', param0, param1, param2, param1).count
        last_page = (item_count <= offset + per_page)
        MyMediaElementsView.where('sti_type = ? AND ((media_element_user_id = ? AND is_public = ?) OR bookmark_user_id = ?)', param0, param1, param2, param1).limit(per_page).offset(offset).each do |me|
          media_element = MediaElement.find_by_id me.id
          media_element.set_status self.id
          resp << media_element
        end
    end
    return {:last_page => last_page, :content => resp, :count => item_count}
  end
  
  def own_lessons(page, per_page, filter=nil)
    page = 1 if page.class != Fixnum || page < 0
    for_page = 1 if for_page.class != Fixnum || for_page < 0
    offset = (page - 1) * per_page
    filter = Filters::ALL_LESSONS if filter.nil? || !Filters::LESSONS_SET.include?(filter)
    resp = []
    last_page = false
    item_count = 0
    my_order = 'updated_at DESC'
    case filter
      when Filters::ALL_LESSONS
        param1 = self.id
        item_count = MyLessonsView.where('lesson_user_id = ? OR bookmark_user_id = ?', param1, param1).count
        last_page = (item_count <= offset + per_page)
        MyLessonsView.where('lesson_user_id = ? OR bookmark_user_id = ?', param1, param1).limit(per_page).offset(offset).each do |l|
          lesson = Lesson.find_by_id l.id
          lesson.set_status self.id
          resp << lesson
        end
      when Filters::PRIVATE
        filtered_query = "is_public =  ? AND user_id = ?"
        param2 = false
        param3 = self.id
        item_count = Lesson.where(filtered_query, param2, param3).count
        last_page = (item_count <= offset + per_page)
        Lesson.where(filtered_query, param2, param3).order(my_order).limit(per_page).offset(offset).each do |l|
          l.set_status self.id
          resp << l
        end
      when Filters::PUBLIC
        param1 = true
        param2 = self.id
        item_count = MyLessonsView.where('is_public = ? AND (lesson_user_id = ? OR bookmark_user_id = ?)', param1, param2, param2).count
        last_page = (item_count <= offset + per_page)
        MyLessonsView.where('is_public = ? AND (lesson_user_id = ? OR bookmark_user_id = ?)', param1, param2, param2).limit(per_page).offset(offset).each do |l|
          lesson = Lesson.find_by_id l.id
          lesson.set_status self.id
          resp << lesson
        end
      when Filters::LINKED
        param1 = self.id
        item_count = MyLessonsView.where('bookmark_user_id = ?', param1).count
        last_page = (item_count <= offset + per_page)
        MyLessonsView.where('bookmark_user_id = ?', param1).limit(per_page).offset(offset).each do |l|
          lesson = Lesson.find_by_id l.id
          lesson.set_status self.id
          resp << lesson
        end
      when Filters::ONLY_MINE
        item_count = Lesson.where(:user_id => self.id).count
        last_page = (item_count <= offset + per_page)
        Lesson.where(:user_id => self.id).order(my_order).limit(per_page).offset(offset).each do |l|
          l.set_status self.id
          resp << l
        end
      when Filters::COPIED
        item_count = Lesson.where(:user_id => self.id, :copied_not_modified => true).count
        last_page = (item_count <= offset + per_page)
        Lesson.where(:user_id => self.id, :copied_not_modified => true).order(my_order).limit(per_page).offset(offset).each do |l|
          l.set_status self.id
          resp << l
        end
    end
    return {:last_page => last_page, :content => resp, :count => item_count}
  end
  
  def suggested_lessons(n)
    n = 1 if n.class != Fixnum || n < 0
    subject_ids = []
    UsersSubject.where(:user_id => self.id).each do |us|
      subject_ids << us.subject_id
    end
    resp = Lesson.where('is_public = ? AND user_id != ? AND subject_id IN (?) AND NOT EXISTS (SELECT * FROM bookmarks WHERE bookmarks.bookmarkable_type = ? AND bookmarks.bookmarkable_id = lessons.id AND bookmarks.user_id = ?)', true, self.id, subject_ids, 'Lesson', self.id).order('updated_at DESC').limit(n)
    resp.each do |l|
      l.set_status self.id
    end
    resp
  end
  
  def suggested_media_elements(n)
    n = 1 if n.class != Fixnum || n < 0
    resp = MediaElement.where('is_public = ? AND user_id != ? AND NOT EXISTS (SELECT * FROM bookmarks WHERE bookmarks.bookmarkable_type = ? AND bookmarks.bookmarkable_id = media_elements.id AND bookmarks.user_id = ?)', true, self.id, 'MediaElement', self.id).order('publication_date DESC').limit(n)
    resp.each do |me|
      me.set_status self.id
    end
    resp
  end
  
  def bookmark(type, target_id)
    return false if self.new_record?
    b = Bookmark.new
    b.bookmarkable_type = type
    b.user_id = self.id
    b.bookmarkable_id = target_id
    b.save
  end
  
  def full_virtual_classroom(page, per_page)
    page = 1 if page.class != Fixnum || page < 0
    for_page = 1 if for_page.class != Fixnum || for_page < 0
    offset = (page - 1) * for_page
    resp = {}
    resp[:last_page] = VirtualClassroomLesson.where('user_id = ?', self.id).offset(offset + per_page).empty?
    resp[:content] = VirtualClassroomLesson.where('user_id = ?', self.id).order('created_at DESC').offset(offset).limit(per_page)
    return resp
  end
  
  def playlist_visible_block(an_offset, a_limit)
    return [] if self.new_record?
    offset = 1 if offset.class != Fixnum || offset < 0
    limit = 1 if limit.class != Fixnum || limit < 0
    VirtualClassroomLesson.where('user_id = ? AND position IS NOT NULL', self.id).order(:position).offset(an_offset).limit(a_limit)
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
  
  def search_media_elements_with_chosen_tag(tag_id, offset, limit, filter, order_by)
    
  end
  
  def search_media_elements_with_tag(word, offset, limit, filter, order_by)
    resp = {}
    params = ["%#{word}%", true, self.id]
    select = 'media_elements.id AS media_element_id'
    joins = "INNER JOIN tags ON (tags.id = taggings.tag_id) INNER JOIN media_elements ON (taggings.taggable_type = 'MediaElement' AND taggings.taggable_id = media_elements.id)"
    where = 'tags.word LIKE ? AND (media_elements.is_public = ? OR media_elements.user_id = ?)'
    order = ''
    case order_by
      when SearchOrders::UPDATED_AT
        order = 'media_elements.updated_at DESC'
      when SearchOrders::TITLE
        order = 'media_elements.title ASC, media_elements.updated_at DESC'
    end
    case filter
      when Filters::VIDEO
        where = "#{where} AND media_elements.sti_type = 'Video'"
      when Filters::AUDIO
        where = "#{where} AND media_elements.sti_type = 'Audio'"
      when Filters::IMAGE
        where = "#{where} AND media_elements.sti_type = 'Image'"
    end
    content = []
    Tagging.group('media_elements.id').select(select).joins(joins).where(where, params[0], params[1], params[2]).order(order).offset(offset).limit(limit).each do |q|
      media_element = MediaElement.find_by_id q.media_element_id
      media_element.set_status self.id
      content << media_element
    end
    resp[:last_page] = Tagging.group('media_elements.id').joins(joins).where(where, params[0], params[1], params[2]).offset(offset + limit).empty?
    resp[:content] = content
    return resp
  end
  
  def search_media_elements_without_tag(offset, limit, filter, order_by)
    resp = {}
    order = ''
    case order_by
      when SearchOrders::UPDATED_AT
        order = 'updated_at DESC'
      when SearchOrders::TITLE
        order = 'title ASC, updated_at DESC'
    end
    last_page = nil
    query = []
    case filter
      when Filters::ALL_MEDIA_ELEMENTS
        last_page = MediaElement.where('is_public = ? OR user_id = ?', true, self.id).offset(offset + limit).empty?
        query = MediaElement.where('is_public = ? OR user_id = ?', true, self.id).order(order).offset(offset).limit(limit)
      when Filters::VIDEO
        last_page = Video.where('is_public = ? OR user_id = ?', true, self.id).offset(offset + limit).empty?
        query = Video.where('is_public = ? OR user_id = ?', true, self.id).order(order).offset(offset).limit(limit)
      when Filters::AUDIO
        last_page = Audio.where('is_public = ? OR user_id = ?', true, self.id).offset(offset + limit).empty?
        query = Audio.where('is_public = ? OR user_id = ?', true, self.id).order(order).offset(offset).limit(limit)
      when Filters::IMAGE
        last_page = Image.where('is_public = ? OR user_id = ?', true, self.id).offset(offset + limit).empty?
        query = Image.where('is_public = ? OR user_id = ?', true, self.id).order(order).offset(offset).limit(limit)
    end
    content = []
    query.each do |q|
      q.set_status self.id
      content << q
    end
    resp[:last_page] = last_page
    resp[:content] = content
    return resp
  end
  
  def search_lessons_with_chosen_tag(tag_id, offset, limit, filter, subject_id, order)
    
  end
  
  def search_lessons_with_tag(word, offset, limit, filter, subject_id, order_by)
    resp = {}
    params = ["%#{word}%"]
    select = 'lessons.id AS lesson_id'
    joins = "INNER JOIN tags ON (tags.id = taggings.tag_id) INNER JOIN lessons ON (taggings.taggable_type = 'Lesson' AND taggings.taggable_id = lessons.id)"
    where = 'tags.word LIKE ?'
    order = ''
    case order_by
      when SearchOrders::UPDATED_AT
        order = 'lessons.updated_at DESC'
      when SearchOrders::LIKES
        select = "#{select}, (SELECT COUNT(*) FROM likes WHERE (likes.lesson_id = lessons.id)) AS likes_count"
        order = 'likes_count DESC, lessons.updated_at DESC'
      when SearchOrders::TITLE
        order = 'lessons.title ASC, lessons.updated_at DESC'
    end
    if !subject_id.nil?
      where = "#{where} AND lessons.subject_id = ?"
      params << subject_id
    end
    case filter
      when Filters::ALL_LESSONS
        where = "#{where} AND (lessons.is_public = ? OR lessons.user_id = ?)"
        params << true
        params << self.id
      when Filters::PUBLIC
        where = "#{where} AND lessons.is_public = ?"
        params << true
      when Filters::ONLY_MINE
        where = "#{where} AND lessons.user_id = ?"
        params << self.id
      when Filters::NOT_MINE
        where = "#{where} AND lessons.is_public = ? AND lessons.user_id != ?"
        params << true
        params << self.id
    end
    query = []
    last_page = nil
    case params.length
      when 2
        query = Tagging.group('lessons.id').select(select).joins(joins).where(where, params[0], params[1]).order(order).offset(offset).limit(limit)
        last_page = Tagging.group('lessons.id').joins(joins).where(where, params[0], params[1]).offset(offset + limit).empty?
      when 3
        query = Tagging.group('lessons.id').select(select).joins(joins).where(where, params[0], params[1], params[2]).order(order).offset(offset).limit(limit)
        last_page = Tagging.group('lessons.id').joins(joins).where(where, params[0], params[1], params[2]).offset(offset + limit).empty?
      when 4
        query = Tagging.group('lessons.id').select(select).joins(joins).where(where, params[0], params[1], params[2], params[3]).order(order).offset(offset).limit(limit)
        last_page = Tagging.group('lessons.id').joins(joins).where(where, params[0], params[1], params[2], params[3]).offset(offset + limit).empty?
    end
    content = []
    query.each do |q|
      lesson = Lesson.find_by_id q.lesson_id
      lesson.set_status self.id
      content << lesson
    end
    resp[:last_page] = last_page
    resp[:content] = content
    return resp
  end
  
  def search_lessons_without_tag(offset, limit, filter, subject_id, order_by)
    resp = {}
    params = []
    select = 'lessons.id AS lesson_id'
    where = ''
    order = ''
    case order_by
      when SearchOrders::UPDATED_AT
        order = 'updated_at DESC'
      when SearchOrders::LIKES
        select = "#{select}, (SELECT COUNT(*) FROM likes WHERE (likes.lesson_id = lessons.id)) AS likes_count"
        order = 'likes_count DESC, updated_at DESC'
      when SearchOrders::TITLE
        order = 'title ASC, updated_at DESC'
    end
    case filter
      when Filters::ALL_LESSONS
        where = '(is_public = ? OR user_id = ?)'
        params << true
        params << self.id
      when Filters::PUBLIC
        where = 'is_public = ?'
        params << true
      when Filters::ONLY_MINE
        where = 'user_id = ?'
        params << self.id
      when Filters::NOT_MINE
        where = 'is_public = ? AND user_id != ?'
        params << true
        params << self.id
    end
    if !subject_id.nil?
      where = "#{where} AND subject_id = ?"
      params << subject_id
    end
    query = []
    last_page = nil
    case params.length
      when 1
        query = Lesson.select(select).where(where, params[0]).order(order).offset(offset).limit(limit)
        last_page = Lesson.where(where, params[0]).offset(offset + limit).empty?
      when 2
        query = Lesson.select(select).where(where, params[0], params[1]).order(order).offset(offset).limit(limit)
        last_page = Lesson.where(where, params[0], params[1]).offset(offset + limit).empty?
      when 3
        query = Lesson.select(select).where(where, params[0], params[1], params[2]).order(order).offset(offset).limit(limit)
        last_page = Lesson.where(where, params[0], params[1], params[2]).offset(offset + limit).empty?
    end
    content = []
    query.each do |q|
      lesson = Lesson.find_by_id q.lesson_id
      lesson.set_status self.id
      content << lesson
    end
    resp[:last_page] = last_page
    resp[:content] = content
    return resp
  end
  
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
