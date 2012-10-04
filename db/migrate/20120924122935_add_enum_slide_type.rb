class AddEnumSlideType < ActiveRecord::Migration
  
  def up
    execute "CREATE TYPE slide_type AS ENUM ('cover', 'text', 'image1', 'image2', 'image3', 'audio1', 'audio2', 'video1', 'video2')"
  end
  
  def down
    execute "DROP TYPE slide_type"
  end
  
end
