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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141216150727) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "blog_posts", force: true do |t|
    t.text     "content"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_posts", ["page_id"], name: "index_blog_posts_on_page_id"

  create_table "pages", force: true do |t|
    t.integer  "number"
    t.text     "content"
    t.integer  "story_id"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["number"], name: "index_pages_on_number"
  add_index "pages", ["story_id"], name: "index_pages_on_story_id"

  create_table "pages_tags", force: true do |t|
    t.integer "page_id"
    t.integer "tag_id"
  end

  add_index "pages_tags", ["page_id", "tag_id"], name: "index_pages_tags_on_page_id_and_tag_id"

  create_table "stories", force: true do |t|
    t.string   "name"
    t.string   "link"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories", ["link"], name: "index_stories_on_link"

  create_table "tags", force: true do |t|
    t.string "value"
  end

  add_index "tags", ["value"], name: "index_tags_on_value", unique: true

end
