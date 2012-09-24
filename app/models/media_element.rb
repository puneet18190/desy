class MediaElement < ActiveRecord::Base
  
  has_many :bookmarks, :as => :bookmarkable
  has_many :likes, :as => :likeable
  has_many :media_elements_slides
  has_many :reports, :as => :reportable
  belongs_to :user
  
end
