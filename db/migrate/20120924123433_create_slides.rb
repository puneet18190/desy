class CreateSlides < ActiveRecord::Migration
  
  def change
    create_table :slides do |t|
      t.integer :lesson_id, :null => false
      t.string :title
      t.text :text1
      t.text :text2
      t.integer :position, :null => false
      t.column :type, :slide_type, :null => false
      t.timestamps
    end
  end
  
end
