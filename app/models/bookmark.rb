class Bookmark < ActiveRecord::Base
  
  belongs_to :bookmarkable, :polymorphic => true
  
end
