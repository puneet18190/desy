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
  
  def get_playlist
    return [] if self.new_record?
    VirtualClassroomLesson.where('user_id = ? AND position IS NOT NULL', self.id).order(:position)
  end
  
  def get_virtual_classroom
    return [] if self.new_record?
    VirtualClassroomLesson.where('user_id = ?', self.id).order(:created_at)
  end
  
  def self.create_user an_email, a_name, a_surname, a_school, a_school_level_id, a_location_id, subject_ids
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
  
  def edit_fields a_name, a_surname, a_school, a_school_level_id, a_location_id, subject_ids
    return false if subject_ids.class != Array || subject_ids.empty? || self.new_record?
    resp = false
    self.name = a_name
    self.surname = a_surname
    self.school_level_id = a_school_level_id
    self.school = a_school
    self.location_id = a_location_id
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback if !self.save
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
            raise ActiveRecord::Rollback if !us.save
          end
        end
        raise ActiveRecord::Rollback if !self.save
      rescue ActiveRecord::InvalidForeignKey
        raise ActiveRecord::Rollback
      end
      resp = true
    end
    resp
  end
  
  def destroy_with_dependencies
    return false if self.new_record?
    resp = true
    ActiveRecord::Base.transaction do
      begin
        Lesson.where(:user_id => self.id).each do |l|
          l.destroy
        end
        UsersSubject.where(:user_id => self.id).each do |us|
          us.destroy
        end
        MediaElement.where(:user_id => self.id).each do |me|
          if me.is_public
            me.user_id = User.find_by_email(VARIABLES['admin_email']).id
            if !me.save
              resp = false
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
        resp = false
        raise ActiveRecord::Rollback
      end
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
