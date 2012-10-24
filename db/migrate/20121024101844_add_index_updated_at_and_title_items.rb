class AddIndexUpdatedAtAndTitleItems < ActiveRecord::Migration
  
  def up
    execute 'CREATE INDEX index_lessons_on_updated_at ON lessons (updated_at DESC)'
    execute 'CREATE INDEX index_media_elements_on_updated_at ON media_elements (updated_at DESC)'
    execute 'CREATE INDEX index_lessons_on_title ON lessons (title DESC)'
    execute 'CREATE INDEX index_media_elements_on_title ON media_elements (title DESC)'
  end
  
  def down
    execute 'DROP INDEX index_lessons_on_updated_at'
    execute 'DROP INDEX index_media_elements_on_updated_at'
    execute 'DROP INDEX index_lessons_on_title'
    execute 'DROP INDEX index_media_elements_on_title'
  end
  
end
