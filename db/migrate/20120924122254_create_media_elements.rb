class CreateMediaElements < ActiveRecord::Migration
  
  def change
    create_table :media_elements do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.text :description, :null => false
      t.integer :duration
      t.string :sti_type, :null => false
      t.boolean :public, :default => false, :null => false
      t.timestamps
    end
  end
  
end
