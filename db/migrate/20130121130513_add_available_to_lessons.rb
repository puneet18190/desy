class AddAvailableToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :available, :boolean, :default => true, :null => false
  end
end
