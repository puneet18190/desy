class CreateNotifications < ActiveRecord::Migration
  
  def change
    create_table :notifications do |t|
      t.integer :user_id, :null => false
      t.text :message, :null => false
      t.boolean :seen, :default => false
      t.timestamps
    end
  end
  
end
