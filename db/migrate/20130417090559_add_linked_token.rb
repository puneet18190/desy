class AddLinkedToken < ActiveRecord::Migration
  
  def up
    add_column :lessons, :linked_token, :string, :null => false
  end
  
  def down
    remove_column :lessons, :linked_token
  end
  
end
