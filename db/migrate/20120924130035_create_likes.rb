class CreateLikes < ActiveRecord::Migration
  
  def change
    create_table :likes do |t|
      t.integer :likable_id, :references => nil, :null => false
      t.column :likable_type, :teaching_object, :null => false, :index => {:with => [:user_id, :likable_id], :unique => true}
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
  
end
