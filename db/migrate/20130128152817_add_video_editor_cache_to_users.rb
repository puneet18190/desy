class AddVideoEditorCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :video_editor_cache, :text
  end
end
