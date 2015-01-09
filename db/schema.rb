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

ActiveRecord::Schema.define(version: 20150109142717) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed"
  end

  create_table "descriptions", force: true do |t|
    t.integer  "author_id"
    t.integer  "described_id"
    t.text     "content"
    t.integer  "status"
    t.string   "additional_authors"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "interests"
    t.string   "hobbies"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.boolean  "female"
    t.boolean  "male"
    t.boolean  "student"
    t.boolean  "teacher"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logins", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mobile_device"
  end

  create_table "memberships", force: true do |t|
    t.integer  "member_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: true do |t|
    t.string   "subject"
    t.string   "author"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poll_options", force: true do |t|
    t.string   "name"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poll_votes", force: true do |t|
    t.integer  "poll_id"
    t.integer  "poll_option_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "polls", force: true do |t|
    t.string   "name"
    t.string   "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed"
    t.boolean  "public_addable_options"
    t.boolean  "multiple",               default: false
  end

  create_table "quotes", force: true do |t|
    t.string   "sender"
    t.text     "text"
    t.boolean  "teacher"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.string   "name"
    t.boolean  "gender"
    t.string   "mail_address"
    t.string   "password_digest"
    t.string   "auth_token"
    t.boolean  "admin_permissions"
    t.boolean  "closed"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_seen_at"
  end

  create_table "teachers", force: true do |t|
    t.string   "name"
    t.boolean  "gender"
    t.boolean  "closed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", force: true do |t|
    t.integer  "voter_id"
    t.string   "voted_type"
    t.integer  "voted_id"
    t.integer  "category_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
