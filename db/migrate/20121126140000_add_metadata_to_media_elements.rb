class AddMetadataToMediaElements < ActiveRecord::Migration
  def change
    add_column :media_elements, :metadata, :text
  end
end
