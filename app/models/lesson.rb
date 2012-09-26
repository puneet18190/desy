class Lesson < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :subject
  belongs_to :school_level
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :likes
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :taggings, :as => :taggable, :dependent => :destroy
  has_many :slides
  has_many :virtual_classroom_lessons
  
end
