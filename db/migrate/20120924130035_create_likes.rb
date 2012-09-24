class CreateLikes < ActiveRecord::Migration
  
  def change
    create_table :likes do |t|
      t.integer :likable_id, :references => nil, :null => false
      t.column :likable_type, :teaching_object, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
  
end
