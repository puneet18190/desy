class Lesson < ActiveRecord::Base
  
  has_many :bookmarks, :as => :bookmarkable
  
end
