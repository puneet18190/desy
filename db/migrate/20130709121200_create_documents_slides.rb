class CreateDocumentsSlides < ActiveRecord::Migration
  
  def change
    create_table :documents_slides do |t|
      t.integer :user_id,             :null => false
      t.integer :slide_id,            :null => false
      t.timestamps
    end
  end
  
end
