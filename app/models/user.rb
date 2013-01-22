class User < ActiveRecord::Base
  
  include Authentication

  attr_accessor :password

  attr_accessible :password, :password_confirmation, :name, :surname, :school_level_id, :school, :location_id, :subject_ids
  
  has_many :bookmarks
  has_many :notifications
  has_many :likes
  has_many :lessons
  has_many :media_elements
  has_many :reports
  has_many :users_subjects
  has_many :subjects, through: :users_subjects
  has_many :virtual_classroom_lessons
  belongs_to :school_level
  belongs_to :location
  
  validates_presence_of :email, :name, :surname, :school_level_id, :school, :location_id
  validates_numericality_of :school_level_id, :location_id, :only_integer => true, :greater_than => 0
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email
  validates_length_of :name, :surname, :email, :school, :maximum => 255
  validates_length_of :password, :minimum => 8, :allow_nil => true
  validate :validate_associations, :validate_email, :validate_email_not_changed
  
  before_validation :init_validation

  scope :confirmed, where(confirmed: true)

  class << self
    def admin
      find_by_email SETTINGS['admin']['email']
    end

    def create_user(email, password, password_confirmation, name, surname, school, school_level_id, location_id, subject_ids, confirmed = false, raise_exception_if_fail = false)
      return nil if !subject_ids.instance_of?(Array) || subject_ids.empty?
      new_user = new :name                  => name, 
                     :surname               => surname, 
                     :school_level_id       => school_level_id, 
                     :school                => school, 
                     :location_id           => location_id,
                     :password              => password,
                     :password_confirmation => password_confirmation
      new_user.email = email
      new_user.confirmed = confirmed
      ActiveRecord::Base.transaction do
        begin
          new_user.save!
        rescue ActiveRecord::RecordInvalid => e
          if raise_exception_if_fail
            raise(e)
          else
            return nil
          end
        end
        subject_ids.each do |s|
          new_users_subject = UsersSubject.new
          new_users_subject.user_id = new_user.id
          new_users_subject.subject_id = s
          begin
            new_users_subject.save!
          rescue ActiveRecord::RecordInvalid => e
            unless raise_exception_if_fail
              new_user = nil
              raise ActiveRecord::Rollback
            end
            raise e
          end
        end
      end
      new_user
    end
  end

  def full_name
    "#{self.name} #{self.surname}"
  end
  
  def video_editor_available
    Video.where('converted IS NULL AND user_id = ?', self.id).empty?
  end
  
  def empty_video_editor_cache # FIXME chiamare la sessione
    return false if self.new_record?
    cache = Rails.root.join("tmp/cache/video_editor/#{self.id}/cache.yml")
    if File.exists?(cache)
      File.delete(cache)
    end
    true
  end
  
  def video_editor_cache # FIXME chiamare la sessione
    cache = Rails.root.join("tmp/cache/video_editor/#{self.id}/cache.yml")
    return nil if self.new_record? || !File.exists?(cache)
    YAML::load(File.open(cache))
  end
  
  def save_video_editor_cache(hash) # FIXME chiamare la sessione
    return false if self.new_record?
    folder = Rails.root.join "tmp/cache/video_editor/#{self.id}"
    FileUtils.mkdir_p folder if !Dir.exists? folder
    x = File.open folder.join("cache.yml"), 'w'
    x.write hash.to_yaml
    x.close
    true
  end
  
  def search_media_elements(word, page, for_page, order=nil, filter=nil)
    page = 1 if page.class != Fixnum || page <= 0
    for_page = 1 if for_page.class != Fixnum || for_page <= 0
    filter = Filters::ALL_MEDIA_ELEMENTS if filter.nil? || !Filters::MEDIA_ELEMENTS_SEARCH_SET.include?(filter)
    order = SearchOrders::UPDATED_AT if order.nil? || !SearchOrders::MEDIA_ELEMENTS_SET.include?(order)
    offset = (page - 1) * for_page
    if word.blank?
      search_media_elements_without_tag(offset, for_page, filter, order)
    else
      word = word.to_s if word.class != Fixnum
      search_media_elements_with_tag(word, offset, for_page, filter, order)
    end
  end
  
  def search_lessons(word, page, for_page, order=nil, filter=nil, subject_id=nil)
    page = 1 if page.class != Fixnum || page <= 0
    for_page = 1 if for_page.class != Fixnum || for_page <= 0
    subject_id = nil if ![NilClass, Fixnum].include?(subject_id.class)
    filter = Filters::ALL_LESSONS if filter.nil? || !Filters::LESSONS_SEARCH_SET.include?(filter)
    order = SearchOrders::UPDATED_AT if order.nil? || !SearchOrders::LESSONS_SET.include?(order)
    offset = (page - 1) * for_page
    if word.blank?
      search_lessons_without_tag(offset, for_page, filter, subject_id, order)
    else
      word = word.to_s if word.class != Fixnum
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
  
  def own_media_elements(page, per_page, filter = nil)
    page = 1 if !page.is_a?(Fixnum) || page <= 0
    for_page = 1 if !for_page.is_a?(Fixnum) || for_page <= 0
    offset = (page - 1) * per_page
    relation = MyMediaElementsView.where('(media_element_user_id = ? AND is_public = false) OR bookmark_user_id = ?', self.id, self.id).includes(:media_element)
    if [ Filters::VIDEO, Filters::AUDIO, Filters::IMAGE ].include? filter
      relation = relation.where('sti_type = ?', filter.capitalize)
    end
    pages_amount = Rational(relation.count, per_page).ceil
    resp = []
    relation.limit(per_page).offset(offset).each do |me|
      media_element = me.media_element
      media_element.set_status self.id
      resp << media_element
    end
    { records: resp, pages_amount: pages_amount }
  end
  
  def own_lessons(page, per_page, filter = nil)
    page = 1 if !page.is_a?(Fixnum) || page <= 0
    for_page = 1 if !for_page.is_a?(Fixnum) || for_page <= 0
    offset = (page - 1) * per_page
    updated_at_order = 'updated_at DESC'
    relation = 
      case filter
      when Filters::PRIVATE
        MyLessonsView.where("is_public = false AND lesson_user_id = ?", self.id).order(updated_at_order)
      when Filters::PUBLIC
        MyLessonsView.where('is_public = true AND (lesson_user_id = ? OR bookmark_user_id = ?)', self.id, self.id)
      when Filters::LINKED
        MyLessonsView.where('bookmark_user_id = ?', self.id)
      when Filters::ONLY_MINE
        MyLessonsView.where(:lesson_user_id => self.id).order(updated_at_order)
      when Filters::COPIED
        MyLessonsView.where(:lesson_user_id => self.id, :copied_not_modified => true).order(updated_at_order)
      else # Filter::ALL_LESSONS
        MyLessonsView.where('lesson_user_id = ? OR bookmark_user_id = ?', self.id, self.id)
      end.includes(:lesson)
    pages_amount = Rational(relation.count, per_page).ceil
    resp = []
    relation.limit(per_page).offset(offset).each do |l|
      lesson = l.lesson
      lesson.set_status self.id
      resp << lesson
    end
    { records: resp, pages_amount: pages_amount }
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
  
  def empty_virtual_classroom
    VirtualClassroomLesson.where(:user_id => self.id).each do |vcl|
      vcl.destroy
    end
  end
  
  def empty_playlist
    return false if self.new_record?
    resp = false
    ActiveRecord::Base.transaction do
      VirtualClassroomLesson.where('user_id = ? AND position IS NOT NULL', self.id).order('position DESC').each do |vcl|
        vcl.position = nil
        raise ActiveRecord::Rollback if !vcl.save
      end
      resp = true
    end
    resp
  end
  
  def full_virtual_classroom(page, per_page)
    page = 1 if !page.is_a?(Fixnum) || page <= 0
    for_page = 1 if !for_page.is_a?(Fixnum) || for_page <= 0
    offset = (page - 1) * per_page
    resp = {}
    resp[:pages_amount] = Rational(VirtualClassroomLesson.where(:user_id => self.id).count, per_page).ceil
    resp[:records] = VirtualClassroomLesson.includes(:lesson).where(:user_id => self.id).order('created_at DESC').offset(offset).limit(per_page)
    return resp
  end
  
  def tot_notifications_number
    Notification.where(:user_id => self.id).count
  end
  
  def destroy_notification_and_reload(notification_id, offset)
    notification_id = 0 if !notification_id.is_a?(Fixnum) || notification_id < 0
    offset = 0 if !offset.is_a?(Fixnum) || offset < 0
    resp = nil
    ActiveRecord::Base.transaction do
      n = Notification.find_by_id(notification_id)
      raise ActiveRecord::Rollback if n.nil? || n.user_id != self.id
      n.destroy
      resp_last = Notification.order('created_at DESC').where(:user_id => self.id).limit(offset).last
      resp_offset = Notification.where(:user_id => self.id).limit(offset).count
      resp_last = nil if ([resp_offset, resp_offset] != [SETTINGS['notifications_loaded_together'], offset])
      resp = {:last => resp_last, :offset => resp_offset}
    end
    resp
  end
  
  def notifications_visible_block(offset, limit)
    Notification.order('created_at DESC').where(:user_id => self.id).offset(offset).limit(limit)
  end
  
  def number_notifications_not_seen
    Notification.where(:seen => false, :user_id => self.id).count
  end
  
  def playlist_full?
    VirtualClassroomLesson.where('user_id = ? AND position IS NOT NULL', self.id).count == SETTINGS['lessons_in_playlist']
  end
  
  def playlist
    VirtualClassroomLesson.includes(:lesson).where('user_id = ? AND position IS NOT NULL', self.id).order(:position)
  end
  
  def create_lesson(title, description, subject_id, tags)
    return nil if self.new_record?
    return {:subject_id => "is not your subject"} if UsersSubject.where(:user_id => self.id, :subject_id => subject_id).empty?
    lesson = Lesson.new :subject_id => subject_id, :school_level_id => self.school_level_id, :title => title, :description => description
    lesson.copied_not_modified = false
    lesson.user_id = self.id
    lesson.tags = tags
    return lesson.save ? lesson : lesson.errors.messages
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
            me.user_id = self.class.admin.id
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
  
  def search_media_elements_with_tag(word, offset, limit, filter, order_by)
    resp = {}
    params = ["#{word}%", true, self.id]
    select = 'media_elements.id AS media_element_id'
    joins = "INNER JOIN tags ON (tags.id = taggings.tag_id) INNER JOIN media_elements ON (taggings.taggable_type = 'MediaElement' AND taggings.taggable_id = media_elements.id)"
    where = 'tags.word LIKE ? AND (media_elements.is_public = ? OR media_elements.user_id = ?)'
    if word.class == Fixnum
      params = [word, true, self.id]
      joins = "INNER JOIN media_elements ON (taggings.taggable_type = 'MediaElement' AND taggings.taggable_id = media_elements.id)"
      where = 'taggings.tag_id = ? AND (media_elements.is_public = ? OR media_elements.user_id = ?)'
    end
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
    resp[:tags] = Tag.where('word LIKE ?', "#{word}%") if word.class != Fixnum
    resp[:records_amount] = Tagging.group('media_elements.id').joins(joins).where(where, params[0], params[1], params[2]).count.length
    resp[:pages_amount] = Rational(resp[:records_amount], limit).ceil
    resp[:records] = content
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
    count = 0
    query = []
    case filter
      when Filters::ALL_MEDIA_ELEMENTS
        count = MediaElement.where('is_public = ? OR user_id = ?', true, self.id).count
        query = MediaElement.where('is_public = ? OR user_id = ?', true, self.id).order(order).offset(offset).limit(limit)
      when Filters::VIDEO
        count = Video.where('is_public = ? OR user_id = ?', true, self.id).count
        query = Video.where('is_public = ? OR user_id = ?', true, self.id).order(order).offset(offset).limit(limit)
      when Filters::AUDIO
        count = Audio.where('is_public = ? OR user_id = ?', true, self.id).count
        query = Audio.where('is_public = ? OR user_id = ?', true, self.id).order(order).offset(offset).limit(limit)
      when Filters::IMAGE
        count = Image.where('is_public = ? OR user_id = ?', true, self.id).count
        query = Image.where('is_public = ? OR user_id = ?', true, self.id).order(order).offset(offset).limit(limit)
    end
    content = []
    query.each do |q|
      q.set_status self.id
      content << q
    end
    resp[:records_amount] = count
    resp[:pages_amount] = Rational(resp[:records_amount], limit).ceil
    resp[:records] = content
    return resp
  end
  
  def search_lessons_with_tag(word, offset, limit, filter, subject_id, order_by)
    resp = {}
    params = ["#{word}%"]
    select = 'lessons.id AS lesson_id'
    joins = "INNER JOIN tags ON (tags.id = taggings.tag_id) INNER JOIN lessons ON (taggings.taggable_type = 'Lesson' AND taggings.taggable_id = lessons.id)"
    where = 'tags.word LIKE ?'
    if word.class == Fixnum
      params = [word]
      joins = "INNER JOIN lessons ON (taggings.taggable_type = 'Lesson' AND taggings.taggable_id = lessons.id)"
      where = 'taggings.tag_id = ?'
    end
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
    count = 0
    case params.length
      when 2
        query = Tagging.group('lessons.id').select(select).joins(joins).where(where, params[0], params[1]).order(order).offset(offset).limit(limit)
        count = Tagging.group('lessons.id').joins(joins).where(where, params[0], params[1]).count.length
      when 3
        query = Tagging.group('lessons.id').select(select).joins(joins).where(where, params[0], params[1], params[2]).order(order).offset(offset).limit(limit)
        count = Tagging.group('lessons.id').joins(joins).where(where, params[0], params[1], params[2]).count.length
      when 4
        query = Tagging.group('lessons.id').select(select).joins(joins).where(where, params[0], params[1], params[2], params[3]).order(order).offset(offset).limit(limit)
        count = Tagging.group('lessons.id').joins(joins).where(where, params[0], params[1], params[2], params[3]).count.length
    end
    content = []
    query.each do |q|
      lesson = Lesson.find_by_id q.lesson_id
      lesson.set_status self.id
      content << lesson
    end
    resp[:tags] = Tag.where('word LIKE ?', "#{word}%") if word.class != Fixnum
    resp[:records_amount] = count
    resp[:pages_amount] = Rational(resp[:records_amount], limit).ceil
    resp[:records] = content
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
    count = 0
    case params.length
      when 1
        query = Lesson.select(select).where(where, params[0]).order(order).offset(offset).limit(limit)
        count = Lesson.where(where, params[0]).count
      when 2
        query = Lesson.select(select).where(where, params[0], params[1]).order(order).offset(offset).limit(limit)
        count = Lesson.where(where, params[0], params[1]).count
      when 3
        query = Lesson.select(select).where(where, params[0], params[1], params[2]).order(order).offset(offset).limit(limit)
        count = Lesson.where(where, params[0], params[1], params[2]).count
    end
    content = []
    query.each do |q|
      lesson = Lesson.find_by_id q.lesson_id
      lesson.set_status self.id
      content << lesson
    end
    resp[:records_amount] = count
    resp[:pages_amount] = Rational(resp[:records_amount], limit).ceil
    resp[:records] = content
    return resp
  end
  
  def init_validation
    @user = Valid.get_association self, :id
    @location = Valid.get_association self, :location_id
    @school_level = Valid.get_association self, :school_level_id
  end
  
  def validate_associations
    errors[:location_id] << "doesn't exist" if @location.nil?
    errors[:school_level_id] << "doesn't exist" if @school_level.nil?
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
