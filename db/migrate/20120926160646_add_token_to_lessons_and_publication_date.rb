class AddTokenToLessonsAndPublicationDate < ActiveRecord::Migration
  
  def up
    add_column :lessons, :token, :string
    add_column :media_elements, :publication_date, :datetime
  end
  
  def down
    remove_column :lessons, :token
    remove_column :media_elements, :publication_date
  end
  
end
