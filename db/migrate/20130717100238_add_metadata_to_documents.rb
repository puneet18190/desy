class AddMetadataToDocuments < ActiveRecord::Migration
  
  def change
    add_column :documents, :metadata, :text
    add_column :documents, :attached, :string
  end
  
end
