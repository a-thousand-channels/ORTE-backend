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

ActiveRecord::Schema.define(version: 2020_02_29_181724) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "icons", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.integer "iconset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iconset_id"], name: "index_icons_on_iconset_id"
  end

  create_table "iconsets", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "layers", force: :cascade do |t|
    t.string "title"
    t.string "text"
    t.boolean "published"
    t.integer "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.index ["map_id"], name: "index_layers_on_map_id"
  end

  create_table "maps", force: :cascade do |t|
    t.string "title"
    t.string "text"
    t.boolean "published"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "script"
    t.string "northeast_corner"
    t.string "southwest_corner"
    t.index ["group_id"], name: "index_maps_on_group_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "title"
    t.text "teaser"
    t.text "text"
    t.string "link"
    t.datetime "startdate"
    t.datetime "enddate"
    t.string "lat"
    t.string "lon"
    t.string "location"
    t.string "address"
    t.string "zip"
    t.string "city"
    t.string "country"
    t.boolean "published"
    t.integer "layer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imagelink"
    t.index ["layer_id"], name: "index_places_on_layer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "role", default: "user"
    t.integer "group_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
