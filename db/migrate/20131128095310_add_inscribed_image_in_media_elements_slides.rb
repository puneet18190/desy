class AddInscribedImageInMediaElementsSlides < ActiveRecord::Migration
  
  def up
    add_column :media_elements_slides, :inscribed, :boolean, :null => false, :default => false
  end
  
  def down
    remove_column :media_elements_slides, :inscribed
  end
  
end
