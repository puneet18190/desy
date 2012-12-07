class AddConvertedToMediaElements < ActiveRecord::Migration
  def change
    add_column :media_elements, :converted, :boolean
  end
end
