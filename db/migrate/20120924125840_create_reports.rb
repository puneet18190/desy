class CreateReports < ActiveRecord::Migration
  
  def change
    create_table :reports do |t|
      t.integer :reportable_id, :references => nil, :null => false
      t.column :reportable_type, :teaching_object, :null => false
      t.integer :user_id, :null => false
      t.text :comment, :null => false
      t.timestamps
    end
  end
  
end
