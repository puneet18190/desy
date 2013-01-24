class AddConfirmationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confirmation_token, :string, index: true
  end
end
