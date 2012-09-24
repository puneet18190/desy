class CreateSlides < ActiveRecord::Migration
  
  def change
    create_table :slides do |t|
      t.integer :lesson_id, :null => false, :on_delete => :cascade
      t.string :title
      t.text :text1
      t.text :text2
      t.integer :position, :null => false, :index => {:with => :lesson_id, :unique => true}
      t.column :type, :slide_type, :null => false
      t.timestamps
    end
  end
  
end
