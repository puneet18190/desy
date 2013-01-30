class AddNotifiedToLessons < ActiveRecord::Migration
  
  def change
    add_column :lessons, :notified, :boolean, :null => false, :default => true
  end
  
end
