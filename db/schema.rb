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

ActiveRecord::Schema.define(version: 20140220204113) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.integer  "image_id"
    t.integer  "member_id"
    t.string   "member_name"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.integer  "member_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "remember_token"
    t.boolean  "admin",                  default: false
    t.boolean  "allows_editing",         default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.integer  "spouse_id"
    t.integer  "oldest_ancestor"
    t.date     "birthdate"
    t.boolean  "full_account"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "state"
    t.string   "password_hash"
    t.string   "password_salt"
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["remember_token"], name: "index_members_on_remember_token", using: :btree
  add_index "members", ["state"], name: "index_members_on_state", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "member_id"
    t.text     "content"
    t.integer  "from_member"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: true do |t|
    t.integer  "parent_id"
    t.integer  "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["child_id"], name: "index_relationships_on_child_id", using: :btree
  add_index "relationships", ["parent_id", "child_id"], name: "index_relationships_on_parent_id_and_child_id", unique: true, using: :btree
  add_index "relationships", ["parent_id"], name: "index_relationships_on_parent_id", using: :btree

  create_table "spouse_relationships", force: true do |t|
    t.integer  "member_id"
    t.integer  "spouse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "updates", force: true do |t|
    t.integer  "member_id"
    t.string   "what"
    t.integer  "what_id"
    t.boolean  "viewed",            default: false
    t.boolean  "counted",           default: false
    t.integer  "from_member"
    t.string   "commented_on_type"
    t.integer  "commented_on_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
