class MediaElement < ActiveRecord::Base
  
  self.inheritance_column = :sti_type
  
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :likes, :as => :likeable, :dependent => :destroy
  has_many :media_elements_slides
  has_many :reports, :as => :reportable, :dependent => :destroy
  belongs_to :user
  
end
