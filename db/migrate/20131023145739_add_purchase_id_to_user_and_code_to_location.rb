class AddPurchaseIdToUserAndCodeToLocation < ActiveRecord::Migration
  
  def up
    add_column :users, :purchase_id, :integer
    add_column :locations, :code, :string
  end
  
  def down
    remove_column :users, :purchase_id
    remove_column :locations, :code
  end
  
end
