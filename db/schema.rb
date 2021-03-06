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

ActiveRecord::Schema.define(version: 20151221174843) do

  create_table "bookmarks", force: :cascade do |t|
    t.text     "description"
    t.integer  "bookmark_id"
    t.string   "title"
    t.string   "url"
    t.boolean  "starred"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "progress_timestamp"
    t.datetime "time"
    t.float    "progress"
    t.datetime "retrieved",          default: '2015-12-22 19:03:09', null: false
    t.datetime "stored"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id"

  create_table "evernote_accounts", force: :cascade do |t|
    t.string   "auth_token"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "evernote_accounts", ["user_id"], name: "index_evernote_accounts_on_user_id"

  create_table "instapaper_accounts", force: :cascade do |t|
    t.string   "token"
    t.string   "secret"
    t.string   "username"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "instapaper_accounts", ["user_id"], name: "index_instapaper_accounts_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
