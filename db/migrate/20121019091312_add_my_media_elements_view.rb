class AddMyMediaElementsView < ActiveRecord::Migration
  
  def up
    execute %q[ CREATE VIEW my_media_elements_view AS (
                  SELECT "media_elements"."id" AS id, 
                         "media_elements"."user_id" AS media_element_user_id, 
                         "media_elements"."sti_type" AS sti_type, 
                         "media_elements"."is_public" AS is_public, 
                         "bookmarks"."user_id" AS bookmark_user_id, 
                         GREATEST("bookmarks"."created_at", "media_elements"."updated_at") AS first_order, 
                         LEAST("bookmarks"."created_at", "media_elements"."updated_at") AS second_order 
                  FROM "media_elements" LEFT JOIN "bookmarks" ON "bookmarks"."bookmarkable_id" = "media_elements"."id" AND "bookmarks"."bookmarkable_type" = 'MediaElement' ORDER BY first_order DESC, second_order DESC)]
  end
  
  def down
    execute "DROP VIEW my_media_elements_view"
  end
  
end
