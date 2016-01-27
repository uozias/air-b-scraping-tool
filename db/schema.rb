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

ActiveRecord::Schema.define(version: 20160121155451) do

  create_table "accounts", force: :cascade do |t|
    t.string   "user",       limit: 255
    t.string   "password",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "prices", force: :cascade do |t|
    t.integer  "room_id",     limit: 4
    t.datetime "target_date"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "prices", ["room_id"], name: "index_prices_on_room_id", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "room_id",     limit: 4
    t.datetime "target_date"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "reservations", ["room_id"], name: "index_reservations_on_room_id", using: :btree

  create_table "room_attributes", force: :cascade do |t|
    t.integer  "room_id",    limit: 4
    t.string   "title",      limit: 255
    t.string   "content",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "room_attributes", ["room_id"], name: "index_room_attributes_on_room_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "url",        limit: 255
    t.integer  "capacity",   limit: 4
    t.integer  "airbnb_id",  limit: 8
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "prices", "rooms"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "room_attributes", "rooms"
end
