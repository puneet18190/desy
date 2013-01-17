# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130115155629) do

  create_table "locations", :force => true do |t|
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "school_levels", :force => true do |t|
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",              :null => false
    t.string   "name",               :null => false
    t.string   "surname",            :null => false
    t.integer  "school_level_id",    :null => false
    t.string   "school",             :null => false
    t.string   "encrypted_password"
    t.boolean  "confirmed",          :null => false
    t.integer  "location_id",        :null => false
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.index ["location_id"], :name => "fk__users_location_id", :order => {"location_id" => :asc}
    t.index ["school_level_id"], :name => "fk__users_school_level_id", :order => {"school_level_id" => :asc}
    t.index ["email"], :name => "index_users_on_email", :unique => true, :order => {"email" => :asc}
    t.foreign_key ["location_id"], "locations", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "users_location_id_fkey"
    t.foreign_key ["school_level_id"], "school_levels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "users_school_level_id_fkey"
  end

# Could not dump table "bookmarks" because of following StandardError
#   Unknown type 'teaching_object' for column 'bookmarkable_type'

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.index ["priority", "run_at"], :name => "delayed_jobs_priority", :order => {"priority" => :asc, "run_at" => :asc}
  end

  create_table "subjects", :force => true do |t|
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "lessons", :force => true do |t|
    t.integer  "user_id",                                              :null => false
    t.integer  "school_level_id",                                      :null => false
    t.integer  "subject_id",                                           :null => false
    t.string   "title",                                                :null => false
    t.text     "description",                                          :null => false
    t.boolean  "is_public",                         :default => false, :null => false
    t.integer  "parent_id"
    t.boolean  "copied_not_modified",                                  :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "token",               :limit => 20
    t.index ["parent_id"], :name => "fk__lessons_parent_id", :order => {"parent_id" => :asc}
    t.index ["school_level_id"], :name => "fk__lessons_school_level_id", :order => {"school_level_id" => :asc}
    t.index ["subject_id"], :name => "fk__lessons_subject_id", :order => {"subject_id" => :asc}
    t.index ["user_id"], :name => "fk__lessons_user_id", :order => {"user_id" => :asc}
    t.index ["title"], :name => "index_lessons_on_title", :order => {"title" => :desc}
    t.index ["updated_at"], :name => "index_lessons_on_updated_at", :order => {"updated_at" => :desc}
    t.foreign_key ["parent_id"], "lessons", ["id"], :on_update => :no_action, :on_delete => :set_null, :name => "lessons_parent_id_fkey"
    t.foreign_key ["school_level_id"], "school_levels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "lessons_school_level_id_fkey"
    t.foreign_key ["subject_id"], "subjects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "lessons_subject_id_fkey"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "lessons_user_id_fkey"
  end

  create_table "likes", :force => true do |t|
    t.integer  "lesson_id",  :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["lesson_id"], :name => "fk__likes_lesson_id", :order => {"lesson_id" => :asc}
    t.index ["user_id"], :name => "fk__likes_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["lesson_id"], "lessons", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "likes_lesson_id_fkey"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "likes_user_id_fkey"
  end

  create_table "media_elements", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.string   "title",                               :null => false
    t.text     "description",                         :null => false
    t.string   "sti_type",                            :null => false
    t.boolean  "is_public",        :default => false, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.datetime "publication_date"
    t.string   "media"
    t.text     "metadata"
    t.boolean  "converted"
    t.index ["user_id"], :name => "fk__media_elements_user_id", :order => {"user_id" => :asc}
    t.index ["title"], :name => "index_media_elements_on_title", :order => {"title" => :desc}
    t.index ["updated_at"], :name => "index_media_elements_on_updated_at", :order => {"updated_at" => :desc}
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "media_elements_user_id_fkey"
  end

# Could not dump table "slides" because of following StandardError
#   Unknown type 'slide_type' for column 'kind'

  create_table "media_elements_slides", :force => true do |t|
    t.integer  "media_element_id", :null => false
    t.integer  "slide_id",         :null => false
    t.integer  "position",         :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.text     "caption"
    t.integer  "alignment"
    t.index ["media_element_id"], :name => "fk__media_elements_slides_media_element_id", :order => {"media_element_id" => :asc}
    t.index ["slide_id"], :name => "fk__media_elements_slides_slide_id", :order => {"slide_id" => :asc}
    t.foreign_key ["media_element_id"], "media_elements", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "media_elements_slides_media_element_id_fkey"
    t.foreign_key ["slide_id"], "slides", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "media_elements_slides_slide_id_fkey"
  end

  create_view "my_lessons_view", "SELECT lessons.id, lessons.user_id AS lesson_user_id, lessons.is_public, lessons.copied_not_modified, lessons.updated_at, bookmarks.user_id AS bookmark_user_id, GREATEST(bookmarks.created_at, lessons.updated_at) AS first_order, LEAST(bookmarks.created_at, lessons.updated_at) AS second_order FROM (lessons LEFT JOIN bookmarks ON (((bookmarks.bookmarkable_id = lessons.id) AND (bookmarks.bookmarkable_type = 'Lesson'::teaching_object)))) ORDER BY GREATEST(bookmarks.created_at, lessons.updated_at) DESC, LEAST(bookmarks.created_at, lessons.updated_at) DESC", :force => true
  create_view "my_media_elements_view", "SELECT media_elements.id, media_elements.user_id AS media_element_user_id, media_elements.sti_type, media_elements.is_public, bookmarks.user_id AS bookmark_user_id, GREATEST(bookmarks.created_at, media_elements.updated_at) AS first_order, LEAST(bookmarks.created_at, media_elements.updated_at) AS second_order FROM (media_elements LEFT JOIN bookmarks ON (((bookmarks.bookmarkable_id = media_elements.id) AND (bookmarks.bookmarkable_type = 'MediaElement'::teaching_object)))) ORDER BY GREATEST(bookmarks.created_at, media_elements.updated_at) DESC, LEAST(bookmarks.created_at, media_elements.updated_at) DESC", :force => true
  create_table "notifications", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.text     "message",                       :null => false
    t.boolean  "seen",       :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.index ["user_id"], :name => "fk__notifications_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "notifications_user_id_fkey"
  end

# Could not dump table "reports" because of following StandardError
#   Unknown type 'teaching_object' for column 'reportable_type'

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["session_id"], :name => "index_sessions_on_session_id", :order => {"session_id" => :asc}
    t.index ["updated_at"], :name => "index_sessions_on_updated_at", :order => {"updated_at" => :asc}
  end

  create_table "tags", :force => true do |t|
    t.string   "word",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["word"], :name => "index_tags_on_word", :unique => true, :order => {"word" => :asc}
  end

# Could not dump table "taggings" because of following StandardError
#   Unknown type 'teaching_object' for column 'taggable_type'

  create_table "users_subjects", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "subject_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["subject_id"], :name => "fk__users_subjects_subject_id", :order => {"subject_id" => :asc}
    t.index ["user_id"], :name => "fk__users_subjects_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["subject_id"], "subjects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "users_subjects_subject_id_fkey"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "users_subjects_user_id_fkey"
  end

  create_table "virtual_classroom_lessons", :force => true do |t|
    t.integer  "lesson_id",  :null => false
    t.integer  "user_id",    :null => false
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["lesson_id"], :name => "fk__virtual_classroom_lessons_lesson_id", :order => {"lesson_id" => :asc}
    t.index ["user_id"], :name => "fk__virtual_classroom_lessons_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["lesson_id"], "lessons", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "virtual_classroom_lessons_lesson_id_fkey"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "virtual_classroom_lessons_user_id_fkey"
  end

end
