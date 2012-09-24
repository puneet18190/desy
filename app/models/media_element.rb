class MediaElement < ActiveRecord::Base
  
  has_many :bookmarks, :as => :bookmarkable
  
end
