class SchoolLevel < ActiveRecord::Base
  
  has_many :lessons
  has_many :users
  
end
