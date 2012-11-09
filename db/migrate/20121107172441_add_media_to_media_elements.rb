class AddMediaToMediaElements < ActiveRecord::Migration
  def change
    add_column :media_elements, :media, :string
  end
end
