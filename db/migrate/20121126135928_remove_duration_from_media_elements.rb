class RemoveDurationFromMediaElements < ActiveRecord::Migration
  def up
    remove_column :media_elements, :duration
  end

  def down
    add_column :media_elements, :duration, :integer
  end
end
