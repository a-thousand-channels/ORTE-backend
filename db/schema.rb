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

ActiveRecord::Schema.define(version: 2022_07_18_151007) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "annotations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.bigint "place_id"
    t.bigint "person_id"
    t.boolean "published", default: false
    t.integer "sorting"
    t.text "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "fk_rails_adeffa1c70"
    t.index ["place_id"], name: "fk_rails_51dbcfe977"
  end

  create_table "build_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.bigint "map_id"
    t.bigint "layer_id"
    t.string "output"
    t.string "size"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["layer_id"], name: "index_build_logs_on_layer_id"
    t.index ["map_id"], name: "index_build_logs_on_map_id"
  end

  create_table "friendly_id_slugs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: { slug: 70, scope: 70 }
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: { slug: 140 }
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.text "message"
  end

  create_table "icons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.integer "iconset_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iconset_id"], name: "index_icons_on_iconset_id"
  end

  create_table "iconsets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon_anchor"
    t.string "icon_size"
    t.string "popup_anchor"
    t.string "class_name"
  end

  create_table "images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "licence"
    t.text "source"
    t.string "creator"
    t.integer "place_id"
    t.string "alt"
    t.string "caption"
    t.integer "sorting"
    t.boolean "preview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "itype", default: "image"
    t.index ["place_id"], name: "index_images_on_place_id"
  end

  create_table "layers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.boolean "published"
    t.integer "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
    t.text "text"
    t.boolean "public_submission"
    t.string "slug"
    t.text "credits"
    t.string "mapcenter_lat"
    t.string "mapcenter_lon"
    t.integer "zoom", default: 12
    t.text "teaser"
    t.text "style"
    t.text "basemap_url"
    t.text "basemap_attribution"
    t.string "tooltip_display_mode", default: "none"
    t.string "places_sort_order"
    t.string "background_color", default: ""
    t.boolean "exif_remove", default: true
    t.boolean "rasterize_images", default: false
    t.integer "relations_bending", default: 1
    t.string "relations_coloring", default: "colored"
    t.boolean "use_mapcenter_from_parent_map", default: true
    t.index ["map_id"], name: "index_layers_on_map_id"
    t.index ["slug"], name: "index_layers_on_slug", unique: true
  end

  create_table "maps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.boolean "published"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "script"
    t.string "northeast_corner"
    t.string "southwest_corner"
    t.text "text"
    t.integer "iconset_id"
    t.string "basemap_url"
    t.string "basemap_attribution"
    t.string "slug"
    t.string "popup_display_mode", default: "click"
    t.boolean "show_annotations_on_map", default: false
    t.text "credits"
    t.text "teaser"
    t.text "style"
    t.string "color"
    t.string "mapcenter_lat"
    t.string "mapcenter_lon"
    t.integer "zoom", default: 12
    t.string "tooltip_display_mode", default: "none"
    t.string "places_sort_order"
    t.string "background_color", default: "#454545"
    t.string "preview_url"
    t.boolean "enable_map_to_go", default: false
    t.boolean "enable_privacy_features", default: true
    t.index ["group_id"], name: "index_maps_on_group_id"
    t.index ["slug"], name: "index_maps_on_slug", unique: true
  end

  create_table "mobility_string_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.string "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "people", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
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
    t.integer "icon_id"
    t.boolean "featured"
    t.string "ptype", default: "info"
    t.boolean "shy", default: false
    t.boolean "sensitive", default: false
    t.integer "sensitive_radius", default: 100
    t.index ["layer_id"], name: "index_places_on_layer_id"
  end

  create_table "relations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "relation_from_id"
    t.integer "relation_to_id"
    t.string "rtype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submission_configs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title_intro"
    t.string "subtitle_intro"
    t.text "intro"
    t.string "title_outro"
    t.text "outro"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "use_city_only"
    t.bigint "layer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locales"
    t.index ["layer_id"], name: "index_submission_configs_on_layer_id"
  end

  create_table "submissions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "rights"
    t.boolean "privacy"
    t.string "locale"
    t.bigint "place_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["place_id"], name: "index_submissions_on_place_id"
  end

  create_table "taggings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name", collation: "utf8mb3_bin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
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
    t.datetime "created_at", default: "2021-06-28 17:11:21", null: false
    t.datetime "updated_at", default: "2021-06-28 17:11:21", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "licence"
    t.text "source"
    t.string "creator"
    t.bigint "place_id"
    t.string "alt"
    t.string "caption"
    t.integer "sorting"
    t.boolean "preview"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_videos_on_place_id"
  end

  add_foreign_key "annotations", "people"
  add_foreign_key "annotations", "places"
  add_foreign_key "build_logs", "layers"
  add_foreign_key "build_logs", "maps"
  add_foreign_key "submission_configs", "layers"
  add_foreign_key "submissions", "places"
  add_foreign_key "taggings", "tags"
  add_foreign_key "videos", "places"
end
