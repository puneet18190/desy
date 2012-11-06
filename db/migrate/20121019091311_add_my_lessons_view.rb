class AddMyLessonsView < ActiveRecord::Migration
  
  def up
    execute %q[ CREATE VIEW my_lessons_view AS (
                  SELECT "lessons"."id" AS id, 
                         "lessons"."user_id" AS lesson_user_id, 
                         "lessons"."is_public" AS is_public,
                         "lessons"."copied_not_modified" AS copied_not_modified,
                         "lessons"."updated_at"  AS updated_at,
                         "bookmarks"."user_id" AS bookmark_user_id, 
                         GREATEST("bookmarks"."created_at", "lessons"."updated_at") AS first_order, 
                         LEAST("bookmarks"."created_at", "lessons"."updated_at") AS second_order 
                         FROM "lessons" LEFT JOIN "bookmarks" ON "bookmarks"."bookmarkable_id" = "lessons"."id" AND "bookmarks"."bookmarkable_type" = 'Lesson' ORDER BY first_order DESC, second_order DESC)]
  end
  
  def down
    execute "DROP VIEW my_lessons_view"
  end
  
end
