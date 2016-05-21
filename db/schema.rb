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

ActiveRecord::Schema.define(version: 20160521154858) do

  create_table "friends", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "friend_id",  limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "friends", ["friend_id"], name: "index_friends_on_friend_id", using: :btree
  add_index "friends", ["user_id", "friend_id"], name: "index_friends_on_user_id_and_friend_id", unique: true, using: :btree
  add_index "friends", ["user_id"], name: "index_friends_on_user_id", using: :btree

  create_table "location_users", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,                 null: false
    t.integer  "location_id", limit: 4,                 null: false
    t.boolean  "is_public",             default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "location_users", ["location_id"], name: "fk_rails_5c0ad2f40f", using: :btree
  add_index "location_users", ["user_id", "location_id"], name: "index_location_users_on_user_id_and_location_id", using: :btree
  add_index "location_users", ["user_id"], name: "index_location_users_on_user_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "street",      limit: 255
    t.string   "city",        limit: 255
    t.string   "postal_code", limit: 255
    t.decimal  "lat",                     precision: 15, scale: 10
    t.decimal  "lng",                     precision: 15, scale: 10
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "country",     limit: 255
    t.string   "address",     limit: 255,                           null: false
  end

  add_index "locations", ["lat", "lng"], name: "index_locations_on_lat_and_lng", using: :btree

  create_table "shared_locations", force: :cascade do |t|
    t.integer  "friend_id",        limit: 4, null: false
    t.integer  "location_user_id", limit: 4, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "shared_locations", ["friend_id"], name: "index_shared_locations_on_friend_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255,              null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "friends", "users"
  add_foreign_key "friends", "users", column: "friend_id"
  add_foreign_key "location_users", "locations"
  add_foreign_key "location_users", "users"
  add_foreign_key "shared_locations", "users", column: "friend_id"
end
