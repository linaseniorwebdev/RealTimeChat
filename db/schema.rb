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

ActiveRecord::Schema.define(version: 2019_09_04_091704) do

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.integer "site_id"
    t.integer "user_id"
    t.integer "stuff_id"
    t.integer "visit_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_chat_rooms_on_site_id"
    t.index ["stuff_id"], name: "index_chat_rooms_on_stuff_id"
    t.index ["user_id"], name: "index_chat_rooms_on_user_id"
  end

  create_table "histories", force: :cascade do |t|
    t.integer "site_id"
    t.integer "user_id"
    t.index ["site_id"], name: "index_histories_on_site_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "htmls", force: :cascade do |t|
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "store_id"
    t.integer "site_id"
    t.string "name"
    t.text "url"
    t.boolean "selected", default: false
    t.index ["site_id"], name: "index_items_on_site_id"
    t.index ["store_id"], name: "index_items_on_store_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "chat_room_id"
    t.text "message"
    t.boolean "toUser", default: false
    t.boolean "isPayURL", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
  end

  create_table "sites", force: :cascade do |t|
    t.integer "store_id"
    t.string "uid"
    t.string "name"
    t.string "password"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_sites_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "auth_id"
    t.string "auth_password"
    t.string "name"
    t.boolean "defaultEnable", default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stuffs", force: :cascade do |t|
    t.integer "store_id"
    t.string "uid"
    t.string "name"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_stuffs_on_store_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "token"
    t.integer "site_id", default: 0
    t.datetime "store_enter_time", default: "2019-09-13 09:49:08"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
