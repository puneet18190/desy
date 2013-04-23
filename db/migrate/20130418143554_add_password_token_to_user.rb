class AddPasswordTokenToUser < ActiveRecord::Migration
  
  def change
    add_column :users, :password_token, :string, :index => true
  end
  
end
