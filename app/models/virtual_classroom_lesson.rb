require 'lessons_media_elements_shared'

# == Description
#
# ActiveRecord class that corresponds to the table +virtual_classroom_lessons+: the table represents the instance of a lesson in the user's Virtual Classroom
#
# == Fields
#
# * *lesson_id*: id of the lesson
# * *user_id*: id of the owner of the Virtual Classroom
# * *position*: position of the lesson in the playlist (if it's +nil+, the lesson is not in the playlist)
#
# == Associations
#
# * *user*: reference to the User who owns the Virtual Classroom (*belongs_to*)
# * *lesson*: reference to the Lesson linked in the Virtual Classroom (*belongs_to*)
#
# == Validations
#
# * *presence* with numericality greater than 0 and existence of associated record for +user_id+ and +lesson_id+
# * *numericality* greater than 0 that allows nil for +position+
# * *uniqueness* of the couple [+lesson_id+, +user_id+]
# * *uniqueness* of the couple [+position+, +user_id+] <b>only if the lesson is in the playlist</b>
# * *availability* of the lesson (it must be present in the section 'lesson', it can belong to the owner of the Virtual Classroom, or be linked by him)
# * *the* *lesson* *cannot* *have* *just* *been* *copied* (see the fields of Lesson)
# * *modifications* *not* *available* for the fields +user_id+ and +lesson_id+, if it's not a +new_record+
# * *presence* *in* *playlist* *not* *allowed* if it's a new record
# * *number* of lessons in the playlist must be smaller than the number configured
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# None
#
class VirtualClassroomLesson < ActiveRecord::Base
  
  attr_accessible :position
  
  belongs_to :user
  belongs_to :lesson
  
  validates_presence_of :lesson_id, :user_id
  validates_numericality_of :lesson_id, :user_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :position, :allow_nil => true, :only_integer => true, :greater_than => 0
  validates_uniqueness_of :lesson_id, :scope => :user_id
  validates_uniqueness_of :position, :scope => :user_id, :if => :in_playlist?
  validate :validate_associations, :validate_availability, :validate_copied_not_modified, :validate_impossible_changes, :validate_positions, :validate_playlist_length
  
  before_validation :init_validation
  
  def next_in_playlist
    self.new_record? ? nil : (self.in_playlist? ? VirtualClassroomLesson.where(:user_id => self.user_id, :position => (self.position + 1)).first : nil)
  end
  
  def prev_in_playlist
    self.new_record? ? nil : (self.in_playlist? ? VirtualClassroomLesson.where(:user_id => self.user_id, :position => (self.position - 1)).first : nil)
  end
  
  def in_playlist?
    return false if self.new_record?
    !self.position.blank?
  end
  
  def remove_from_playlist
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_removing_from_playlist)
      return false
    end
    return true if !self.in_playlist?
    resp = false
    my_position = self.position
    ActiveRecord::Base.transaction do
      self.position = nil
      if !self.save
        errors.add(:base, :problem_removing_from_playlist)
        raise ActiveRecord::Rollback
      end
      VirtualClassroomLesson.where('user_id = ? AND position > ?', self.user_id, my_position).order(:position).each do |vcl|
        vcl.position -= 1
        if !vcl.save
          errors.add(:base, :problem_removing_from_playlist)
          raise ActiveRecord::Rollback
        end
      end
      resp = true
    end
    resp
  end
  
  def add_to_playlist
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_adding_to_playlist)
      return false
    end
    user = User.find_by_id(self.user_id)
    if user.nil? || user.playlist_full?
      errors.add(:base, :playlist_full)
      return false
    end
    return true if !self.position.nil?
    VirtualClassroomLesson.where('user_id = ? AND position IS NOT NULL', self.user_id).order('position DESC').each do |vcl|
      vcl.position += 1
      if !vcl.save
        errors.add(:base, :problem_adding_to_playlist)
        return false
      end
    end
    self.position = 1
    if !self.save
      errors.add(:base, :problem_adding_to_playlist)
      return false
    end
    true
  end
  
  def change_position(x)
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_changing_position_in_playlist)
      return false
    end
    if x.class != Fixnum || x <= 0
      errors.add(:base, :invalid_position_in_playlist)
      return false
    end
    y = self.position
    if y.nil?
      errors.add(:base, :problem_changing_position_in_playlist)
      return false
    end
    return true if y == x
    desc = (y > x)
    tot_playlists = VirtualClassroomLesson.where('user_id = ? AND position IS NOT NULL', self.user_id).count
    if x > tot_playlists
      errors.add(:base, :invalid_position_in_playlist)
      return false
    end
    resp = false
    ActiveRecord::Base.transaction do
      self.position = tot_playlists + 2
      if !self.save
        errors.add(:base, :problem_changing_position_in_playlist)
        raise ActiveRecord::Rollback
      end
      empty_pos = y
      while empty_pos != x
        curr_pos = (desc ? (empty_pos - 1) : (empty_pos + 1))
        curr_playlist = VirtualClassroomLesson.where(:user_id => self.user_id, :position => curr_pos).first
        curr_playlist.position = empty_pos
        if !curr_playlist.save
          errors.add(:base, :problem_changing_position_in_playlist)
          raise ActiveRecord::Rollback
        end
        empty_pos = curr_pos
      end
      self.position = x
      if !self.save
        errors.add(:base, :problem_changing_position_in_playlist)
        raise ActiveRecord::Rollback
      end
      resp = true
    end
    resp
  end
  
  private
  
  def validate_playlist_length # :doc:
    errors.add(:position, :reached_maximum_in_playlist) if @virtual_classroom_lesson && @virtual_classroom_lesson.position.nil? && !self.position.nil? && VirtualClassroomLesson.where('user_id = ? AND position IS NOT NULL', @virtual_classroom_lesson.user_id).count == SETTINGS['lessons_in_playlist']
  end
  
  def init_validation # :doc:
    @virtual_classroom_lesson = Valid.get_association self, :id
    @lesson = Valid.get_association self, :lesson_id
    @user = Valid.get_association self, :user_id
  end
  
  def validate_associations # :doc:
    errors.add(:user_id, :doesnt_exist) if @user.nil?
    errors.add(:lesson_id, :doesnt_exist) if @lesson.nil?
  end
  
  def validate_availability # :doc:
    errors.add(:lesson_id, :is_not_available) if @lesson && @user && @lesson.user_id != @user.id && !@lesson.bookmarked?(@user.id)
  end
  
  def validate_copied_not_modified # :doc:
    errors.add(:lesson_id, :just_been_copied) if @lesson && @lesson.copied_not_modified
  end
  
  def validate_positions # :doc:
    errors.add(:position, :must_be_null_if_new_record) if self.new_record? && self.position
  end
  
  def validate_impossible_changes # :doc:
    if @virtual_classroom_lesson
      errors.add(:user_id, :cant_be_changed) if @virtual_classroom_lesson.user_id != self.user_id
      errors.add(:lesson_id, :cant_be_changed) if @virtual_classroom_lesson.lesson_id != self.lesson_id
    end
  end
  
end
