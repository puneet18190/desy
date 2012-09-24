class CreateEnumLessonMediaElement < ActiveRecord::Migration
  
  def up
    execute "CREATE TYPE teaching_object AS ENUM ('lesson', 'media_element')"
  end
  
  def down
    execute "DROP TYPE teaching_object"
  end
  
end
