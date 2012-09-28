class CreateLessons < ActiveRecord::Migration
  
  def change
    create_table :lessons do |t|
      t.integer :user_id, :null => false
      t.integer :school_level_id, :null => false
      t.integer :subject_id, :null => false
      t.string :title, :null => false
      t.text :description, :null => false
      t.boolean :is_public, :default => false, :null => false
      t.integer :parent_id, :on_delete => :set_null
      t.boolean :copied_not_modified, :null => false
      t.timestamps
    end
  end
  
end
