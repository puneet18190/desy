class AddMyLessonsView < ActiveRecord::Migration
  
  def up
    execute "CREATE VIEW my_lessons_view AS (SELECT \"lessons\".\"id\" AS id, \"lessons\".\"user_id\" AS lesson_user_id, \"lessons\".\"is_public\" AS is_public, \"bookmarks\".\"user_id\" AS bookmark_user_id, GREATEST(\"bookmarks\".\"created_at\", \"lessons\".\"updated_at\") AS first_order, LEAST(\"bookmarks\".\"created_at\", \"lessons\".\"updated_at\") AS second_order FROM \"lessons\" LEFT JOIN \"bookmarks\" ON \"bookmarks\".\"bookmarkable_id\" = \"lessons\".\"id\" AND \"bookmarks\".\"bookmarkable_type\" = 'Lesson' ORDER BY first_order DESC, second_order DESC)"
    execute "CREATE VIEW my_media_elements_view AS (SELECT \"media_elements\".\"id\" AS id, \"media_elements\".\"user_id\" AS media_element_user_id, \"media_elements\".\"sti_type\" AS sti_type, \"media_elements\".\"is_public\" AS is_public, \"bookmarks\".\"user_id\" AS bookmark_user_id, GREATEST(\"bookmarks\".\"created_at\", \"media_elements\".\"updated_at\") AS first_order, LEAST(\"bookmarks\".\"created_at\", \"media_elements\".\"updated_at\") AS second_order FROM \"media_elements\" LEFT JOIN \"bookmarks\" ON \"bookmarks\".\"bookmarkable_id\" = \"media_elements\".\"id\" AND \"bookmarks\".\"bookmarkable_type\" = 'MediaElement' ORDER BY first_order DESC, second_order DESC)"
  end
  
  def down
    execute "DROP VIEW my_lessons_view"
    execute "DROP VIEW my_media_elements_view"
  end
  
end
