class CreateBookmarks < ActiveRecord::Migration
  
  def change
    create_table :bookmarks do |t|
      t.integer :user_id, :null => false
      t.integer :bookmarkable_id, :null => false, :references => nil
      t.column :bookmarkable_type, :teaching_object, :null => false
      t.timestamps
    end
  end
  
end
