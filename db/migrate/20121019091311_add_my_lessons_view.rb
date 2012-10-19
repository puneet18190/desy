class AddMyLessonsView < ActiveRecord::Migration
  
  def up
    execute "CREATE VIEW my_lessons_view AS (SELECT \"lessons\".*, GREATEST(\"bookmarks\".\"created_at\", \"lessons\".\"updated_at\") AS first_order, LEAST(\"bookmarks\".\"created_at\", \"lessons\".\"updated_at\") AS second_order FROM \"lessons\" LEFT JOIN \"bookmarks\" ON \"bookmarks\".\"bookmarkable_id\" = \"lessons\".\"id\" AND \"bookmarks\".\"bookmarkable_type\" = 'Lesson' ORDER BY first_order DESC, second_order DESC)"
    execute "CREATE VIEW my_media_elements_view AS (SELECT \"media_elements\".*, GREATEST(\"bookmarks\".\"created_at\", \"media_elements\".\"updated_at\") AS first_order, LEAST(\"bookmarks\".\"created_at\", \"media_elements\".\"updated_at\") AS second_order FROM \"media_elements\" LEFT JOIN \"bookmarks\" ON \"bookmarks\".\"bookmarkable_id\" = \"media_elements\".\"id\" AND \"bookmarks\".\"bookmarkable_type\" = 'MediaElement' ORDER BY first_order DESC, second_order DESC)"
  end
  
  def down
    execute "DROP VIEW my_lessons_view"
    execute "DROP VIEW my_media_elements_view"
  end
  
end
