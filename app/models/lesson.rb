class Lesson < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :subject
  belongs_to :school_level
  has_many :bookmarks, :as => :bookmarkable
  has_many :likes, :as => :likeable
  has_many :reports, :as => :reportable
  has_many :slides
  has_many :virtual_classroom_lessons
  
end
