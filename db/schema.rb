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

ActiveRecord::Schema.define(:version => 20131023145739) do

  create_table "locations", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "sti_type"
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "code"
    t.index ["ancestry"], :name => "index_locations_on_ancestry", :order => {"ancestry" => :asc}
  end

  create_table "purchases", :force => true do |t|
    t.string   "name",             :null => false
    t.string   "responsible",      :null => false
    t.string   "phone_number"
    t.string   "fax"
    t.string   "email",            :null => false
    t.string   "ssn_code"
    t.string   "vat_code"
    t.string   "address"
    t.string   "postal_code"
    t.string   "city"
    t.string   "country"
    t.integer  "location_id"
    t.integer  "accounts_number",  :null => false
    t.boolean  "includes_invoice", :null => false
    t.datetime "release_date",     :null => false
    t.datetime "start_date",       :null => false
    t.datetime "expiration_date",  :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.index ["location_id"], :name => "fk__purchases_location_id", :order => {"location_id" => :asc}
    t.foreign_key ["location_id"], "locations", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_purchases_location_id"
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
    t.string   "encrypted_password", :null => false
    t.boolean  "confirmed",          :null => false
    t.boolean  "active",             :null => false
    t.integer  "location_id"
    t.string   "confirmation_token"
    t.text     "metadata"
    t.string   "password_token"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "purchase_id"
    t.index ["location_id"], :name => "fk__users_location_id", :order => {"location_id" => :asc}
    t.index ["purchase_id"], :name => "fk__users_purchase_id", :order => {"purchase_id" => :asc}
    t.index ["school_level_id"], :name => "fk__users_school_level_id", :order => {"school_level_id" => :asc}
    t.index ["active"], :name => "index_users_on_active", :order => {"active" => :asc}
    t.index ["confirmation_token"], :name => "index_users_on_confirmation_token", :order => {"confirmation_token" => :asc}
    t.index ["confirmed"], :name => "index_users_on_confirmed", :order => {"confirmed" => :asc}
    t.index ["email"], :name => "index_users_on_email", :unique => true, :order => {"email" => :asc}
    t.index ["password_token"], :name => "index_users_on_password_token", :order => {"password_token" => :asc}
    t.foreign_key ["location_id"], "locations", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_users_location_id"
    t.foreign_key ["purchase_id"], "purchases", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_users_purchase_id"
    t.foreign_key ["school_level_id"], "school_levels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_users_school_level_id"
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

  create_table "documents", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "title"
    t.text     "description"
    t.string   "attachment",  :null => false
    t.text     "metadata"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.index ["user_id"], :name => "fk__documents_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_documents_user_id"
  end

  create_table "subjects", :force => true do |t|
    t.string   "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "lessons", :force => true do |t|
    t.string   "uuid", :default => { :expr => "uuid_generate_v4()" },                :limit => nil,                    :null => false
    t.integer  "user_id",                                               :null => false
    t.integer  "school_level_id",                                       :null => false
    t.integer  "subject_id",                                            :null => false
    t.string   "title",                                                 :null => false
    t.text     "description",                                           :null => false
    t.boolean  "is_public",                          :default => false, :null => false
    t.integer  "parent_id"
    t.boolean  "copied_not_modified",                                   :null => false
    t.string   "token",                                                 :null => false
    t.text     "metadata"
    t.boolean  "notified",                           :default => true,  :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.index ["parent_id"], :name => "fk__lessons_parent_id", :order => {"parent_id" => :asc}
    t.index ["school_level_id"], :name => "fk__lessons_school_level_id", :order => {"school_level_id" => :asc}
    t.index ["subject_id"], :name => "fk__lessons_subject_id", :order => {"subject_id" => :asc}
    t.index ["user_id"], :name => "fk__lessons_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["parent_id"], "lessons", ["id"], :on_update => :no_action, :on_delete => :set_null, :name => "fk_lessons_parent_id"
    t.foreign_key ["school_level_id"], "school_levels", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_lessons_school_level_id"
    t.foreign_key ["subject_id"], "subjects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_lessons_subject_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_lessons_user_id"
  end

# Could not dump table "slides" because of following StandardError
#   Unknown type 'slide_type' for column 'kind'

  create_table "documents_slides", :force => true do |t|
    t.integer  "document_id", :null => false
    t.integer  "slide_id",    :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.index ["document_id"], :name => "fk__documents_slides_document_id", :order => {"document_id" => :asc}
    t.index ["slide_id"], :name => "fk__documents_slides_slide_id", :order => {"slide_id" => :asc}
    t.foreign_key ["document_id"], "documents", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_documents_slides_document_id"
    t.foreign_key ["slide_id"], "slides", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_documents_slides_slide_id"
  end

  create_table "likes", :force => true do |t|
    t.integer  "lesson_id",  :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["lesson_id"], :name => "fk__likes_lesson_id", :order => {"lesson_id" => :asc}
    t.index ["user_id"], :name => "fk__likes_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["lesson_id"], "lessons", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_likes_lesson_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_likes_user_id"
  end

  create_table "mailing_list_groups", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["user_id"], :name => "fk__mailing_list_groups_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_mailing_list_groups_user_id"
  end

  create_table "mailing_list_addresses", :force => true do |t|
    t.integer  "group_id"
    t.string   "heading"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["group_id"], :name => "fk__mailing_list_addresses_group_id", :order => {"group_id" => :asc}
    t.foreign_key ["group_id"], "mailing_list_groups", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_mailing_list_addresses_group_id"
  end

  create_table "media_elements", :force => true do |t|
    t.integer  "user_id",                             :null => false
    t.string   "sti_type",                            :null => false
    t.string   "media"
    t.string   "title",                               :null => false
    t.text     "description",                         :null => false
    t.text     "metadata"
    t.boolean  "converted",        :default => false, :null => false
    t.boolean  "is_public",        :default => false, :null => false
    t.datetime "publication_date"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.index ["user_id"], :name => "fk__media_elements_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_media_elements_user_id"
  end

  create_table "media_elements_slides", :force => true do |t|
    t.integer  "media_element_id", :null => false
    t.integer  "slide_id",         :null => false
    t.integer  "position",         :null => false
    t.text     "caption"
    t.integer  "alignment"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.index ["media_element_id"], :name => "fk__media_elements_slides_media_element_id", :order => {"media_element_id" => :asc}
    t.index ["slide_id"], :name => "fk__media_elements_slides_slide_id", :order => {"slide_id" => :asc}
    t.foreign_key ["media_element_id"], "media_elements", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_media_elements_slides_media_element_id"
    t.foreign_key ["slide_id"], "slides", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_media_elements_slides_slide_id"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.text     "message",                       :null => false
    t.boolean  "seen",       :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.index ["user_id"], :name => "fk__notifications_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_notifications_user_id"
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
    t.foreign_key ["subject_id"], "subjects", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_users_subjects_subject_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_users_subjects_user_id"
  end

  create_table "virtual_classroom_lessons", :force => true do |t|
    t.integer  "lesson_id",  :null => false
    t.integer  "user_id",    :null => false
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.index ["lesson_id"], :name => "fk__virtual_classroom_lessons_lesson_id", :order => {"lesson_id" => :asc}
    t.index ["user_id"], :name => "fk__virtual_classroom_lessons_user_id", :order => {"user_id" => :asc}
    t.foreign_key ["lesson_id"], "lessons", ["id"], :on_update => :no_action, :on_delete => :cascade, :name => "fk_virtual_classroom_lessons_lesson_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :no_action, :on_delete => :no_action, :name => "fk_virtual_classroom_lessons_user_id"
  end

end
