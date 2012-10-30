class AddCaptionAndAllignmentToMediaElementsSlide < ActiveRecord::Migration
  
  def up
    add_column :media_elements_slides, :caption, :text
    add_column :media_elements_slides, :allignment, :integer
  end
  
  def down
    remove_column :media_elements_slides, :caption
    remove_column :media_elements_slides, :allignment
  end
  
end
