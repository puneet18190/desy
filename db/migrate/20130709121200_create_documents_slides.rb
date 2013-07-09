class CreateDocumentsSlides < ActiveRecord::Migration
  
  def change
    create_table :documents_slides do |t|
      t.integer :document_id,             :null => false
      t.integer :slide_id,            :null => false
      t.timestamps
    end
  end
  
end
