class AddAvailableToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :metadata, :text
  end
end
