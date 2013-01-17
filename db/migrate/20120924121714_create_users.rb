class CreateUsers < ActiveRecord::Migration
  
  def change
    create_table :users do |t|
      t.string :email, :null => false, :index => :unique
      t.string :name, :null => false
      t.string :surname, :null => false
      t.integer :school_level_id, :null => false
      t.string :school, :null => false
      t.string :encrypted_password
      t.boolean :confirmed, :null => false, :index => true
      t.integer :location_id, :null => false
      t.timestamps
    end
  end
  
end
