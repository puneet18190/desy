class DropSessions < ActiveRecord::Migration
  def change
    remove_index :sessions, column: :session_id
    remove_index :sessions, column: :updated_at

    drop_table :sessions do |t|
      t.string :session_id, :null => false, :references => nil
      t.text :data
      t.timestamps
    end
  end
end
