# == Description
#
# ActiveRecord class that corresponds to the table +subjects+.
#
# == Fields
#
# * *description*: a word identifying the subject
#
# == Associations
#
# * *users_subjects*: list of instances of this subject associated to a User through records of UsersSubject (*has_many*)
# * *lessons*: list of lessons associated to this subjects (see Lesson) (*has_many*)
#
# == Validations
#
# * *presence* of +description+
# * *length* of +description+ (maximum allowed is 255)
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# None
#
class Subject < ActiveRecord::Base
  
  attr_accessible :description
  
  has_many :lessons
  has_many :users_subjects
  
  validates_presence_of :description
  validates_length_of :description, :maximum => 255
  
  # === Description
  #
  # Returns the description of the object
  #
  def to_s
    description.to_s
  end
  
  # === Description
  #
  # Used to generate a graph of the distribution of the subjects among the lessons in the application. Used in UsersController#statistics and in Statistics
  #
  def self.chart_colors
    tot = self.find(Lesson.pluck(:subject_id).uniq).count
    part = (255.to_f/tot).floor
    colors = []
    (0..tot-1).each do |index|
      colors << "rgb(255,#{part*index},0)"
    end
    return colors
  end
  
  # === Description
  #
  # A subject is deletable if it has no associated lessons or users. Used in the administrator (Admin::SettingsController#subjects)
  #
  # === Returns
  #
  # A boolean
  #
  def is_deletable?
    UsersSubject.where(:subject_id => self.id).empty? && Lesson.where(:subject_id => self.id).empty?
  end
  
end
