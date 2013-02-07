class User < ActiveRecord::Base
  
  include Authentication
  include Confirmation

  REGISTRATION_POLICIES = SETTINGS['user_registration_policies'].map(&:to_sym)

  attr_accessor :password
  serialize :video_editor_cache

  ATTR_ACCESSIBLE = [:password, :password_confirmation, :name, :surname, :school_level_id, :school, :location_id, :subject_ids] + REGISTRATION_POLICIES
  attr_accessible *ATTR_ACCESSIBLE
  
  has_many :bookmarks
  has_many :notifications
  has_many :likes
  has_many :lessons
  has_many :media_elements
  has_many :reports
  has_many :users_subjects, dependent: :destroy
  has_many :subjects, through: :users_subjects
  has_many :virtual_classroom_lessons
  has_many :mailing_list_groups, :dependent => :destroy
  belongs_to :school_level
  belongs_to :location
  
  validates_presence_of :email, :name, :surname, :school_level_id, :school, :location_id
  validates_numericality_of :school_level_id, :location_id, :only_integer => true, :greater_than => 0
  validates_confirmation_of :password
  validates_presence_of :users_subjects
  validates_uniqueness_of :email
  validates_length_of :name, :surname, :email, :school, :maximum => 255
  validates_length_of :password, :minimum => 8, :on => :create
  validates_length_of :password, :minimum => 8, :on => :update, :allow_nil => true, :allow_blank => true
  validate :validate_associations
  validate :validate_email_not_changed, on: :update
  validates :email, email_format: { :message => I18n.t(:invalid_email_address, :scope => [:activerecord, :errors, :messages]) }
  REGISTRATION_POLICIES.each do |policy|
    validates_acceptance_of policy, on: :create, allow_nil: false
  end
  
  before_validation :init_validation

  scope :confirmed,     where(confirmed: true)
  scope :not_confirmed, where(confirmed: false)

  class << self
    def admin
      find_by_email SETTINGS['admin']['email']
    end
  end

  def accept_policies
    registration_policies.each{ |p| send("#{p}=", '1') }
  end

  def video_editor_cache!(cache = nil)
    update_attribute :video_editor_cache, cache
    nil
  end

  def audio_editor_cache!(cache = nil)
    return false if self.new_record?
    folder = Rails.root.join "tmp/cache/audio_editor/#{self.id}"
    FileUtils.mkdir_p folder if !Dir.exists? folder
    x = File.open folder.join("cache.yml"), 'w'
    x.write cache.to_yaml
    x.close
    true
  end
  
  def audio_editor_cache
    cache = Rails.root.join("tmp/cache/audio_editor/#{self.id}/cache.yml")
    return nil if self.new_record? || !File.exists?(cache)
    YAML::load(File.open(cache))
  end

  def registration_policies
    REGISTRATION_POLICIES
  end

  def reset_password!
    new_password = SecureRandom.urlsafe_base64(10)
    update_attributes!(password: new_password, password_confirmation: new_password)
    new_password
  end

  def subject_ids=(subject_ids)
    users_subjects.reload.clear
    subject_ids.each { |id| users_subjects.build user: self, subject_id: id } if subject_ids
    subject_ids
  end

  def full_name
    "#{self.name} #{self.surname}"
  end
  
  def video_editor_available
    Video.where('converted IS NULL AND user_id = ?', self.id).empty?
  end
  
  def audio_editor_available
    Audio.where('converted IS NULL AND user_id = ?', self.id).empty?
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
    relation = MediaElement.of(self)
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
  
  def own_lessons(page, per_page, filter = Filters::ALL_LESSONS)
    page = 1 if !page.is_a?(Fixnum) || page <= 0
    for_page = 1 if !for_page.is_a?(Fixnum) || for_page <= 0
    offset = (page - 1) * per_page
    relation = 
      case filter
      when Filters::PRIVATE
        Lesson.where(user_id: self.id, is_public: false).order('updated_at DESC')
      when Filters::PUBLIC
        Lesson.of(self).where(is_public: true)
      when Filters::LINKED
        Lesson.joins(:bookmarks).where(bookmarks: { user_id: self.id }).order('bookmarks.created_at DESC')
      when Filters::ONLY_MINE
        Lesson.where(user_id: self.id).order('updated_at DESC')
      when Filters::COPIED
        Lesson.where(:user_id => self.id, :copied_not_modified => true).order('updated_at DESC')
      when Filters::ALL_LESSONS
        Lesson.of(self)
      else
        raise ArgumentError, 'filter not supported'
      end
    pages_amount = Rational(relation.count, per_page).ceil
    resp = []
    relation.limit(per_page).offset(offset).each do |lesson|
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
    if UsersSubject.where(:user_id => self.id, :subject_id => subject_id).empty?
      lesson = Lesson.new :subject_id => subject_id, :school_level_id => self.school_level_id, :title => title, :description => description
      lesson.copied_not_modified = false
      lesson.user_id = self.id
      lesson.tags = tags
      if lesson.valid?
        return {:subject_id => "is not your subject"}
      else
        resp = lesson.errors.messages
        resp[:subject_id] = "is not your subject"
        return resp
      end
    end
    lesson = Lesson.new :subject_id => subject_id, :school_level_id => self.school_level_id, :title => title, :description => description
    lesson.copied_not_modified = false
    lesson.user_id = self.id
    lesson.tags = tags
    return lesson.save ? lesson : lesson.errors.messages
  end
  
  def destroy_with_dependencies
    if self.new_record?
      errors.add(:base, :problem_destroying)
      return false
    end
    resp = false
    ActiveRecord::Base.transaction do
      begin
        Lesson.where(:user_id => self.id).each do |l|
          if !l.destroy_with_notifications
            errors.add(:base, :problem_destroying)
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
              errors.add(:base, :problem_destroying)
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
        errors.add(:base, :problem_destroying)
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
    errors.add :location_id, :blank if @location.nil?
    errors.add :school_level_id, :blank if @school_level.nil?
  end
  
  def validate_email_not_changed
    errors.add :email, :changed if changed.include? 'email'
  end
  
end
