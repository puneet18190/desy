class CreateMediaElementsSlides < ActiveRecord::Migration
  
  def change
    create_table :media_elements_slides do |t|
      t.integer :media_element_id, :null => false
      t.integer :slide_id, :null => false
      t.integer :position, :null => false
      t.timestamps
    end
  end
  
end
