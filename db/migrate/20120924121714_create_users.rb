class CreateUsers < ActiveRecord::Migration
  
  def change
    create_table :users do |t|
      t.string :email, :null => false
      t.string :name, :null => false
      t.string :surname, :null => false
      t.integer :school_level_id, :null => false
      t.string :school, :null => false
      t.string :password_hash
      t.string :password_salt
      t.integer :location_id, :null => false
      t.timestamps
    end
  end
  
end
