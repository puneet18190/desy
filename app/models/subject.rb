class Subject < ActiveRecord::Base
  
  attr_accessible :description
  
  has_many :lessons
  has_many :users_subjects
  
  validates_presence_of :description
  validates_length_of :description, :maximum => 255

  def to_s
    description.to_s
  end
  
  def self.chart_colors
    tot = self.find(Lesson.pluck(:subject_id).uniq).count
    part = (255.to_f/tot).floor
    colors = []
    (0..tot-1).each do |index|
      colors << "rgb(255,#{part*index},0)"
    end
    return colors
  end
  
  def is_deletable?
    UsersSubject.where(:subject_id => self.id).empty? && Lesson.where(:subject_id => self.id).empty?
  end
  
end
