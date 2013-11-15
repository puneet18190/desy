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
    colors = SETTINGS['graph_colors'].clone
    tot = self.find(Lesson.pluck(:subject_id).uniq).count
    while tot > colors.length
      new_color = "##{("%06x" % (rand * 0xffffff))}"
      while colors.include? new_color
        new_color = "##{("%06x" % (rand * 0xffffff))}"
      end
      colors << new_color
    end
    colors[0..(tot - 1)]
  end
  
  # === Description
  #
  # Used to assign a cathegory to each subject
  #
  def self.extract_with_cathegories
    resp = []
    taken_subjects = []
    cathegories = SETTINGS['subject_cathegories']
    (cathegories.present? ? cathegories : []).each do |cat|
      resp << {:label => cat[0], :items => Subject.where(:id => cat[1]).order(:description)}
      taken_subjects += cat[1]
    end
    resp << {:label => nil, :items => Subject.where('id NOT IN (?)', taken_subjects).order(:description)}
    resp
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
