class CreateLikes < ActiveRecord::Migration
  
  def change
    create_table :likes do |t|
      t.integer :likeable_id, :references => nil, :null => false
      t.column :likeable_type, :teaching_object, :null => false, :index => {:with => [:user_id, :likeable_id], :unique => true}
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
  
end
