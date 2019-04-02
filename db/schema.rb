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

ActiveRecord::Schema.define(version: 2019_03_30_164748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "album_sources", force: :cascade do |t|
    t.string "source_id"
    t.string "source"
    t.bigint "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_album_sources_on_album_id"
  end

  create_table "albums", force: :cascade do |t|
    t.string "added_at"
    t.string "name", null: false
    t.string "release_date"
    t.string "release_type"
    t.integer "total_tracks"
    t.string "img_url"
    t.integer "height"
    t.integer "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "albums_artists", id: false, force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "album_id", null: false
  end

  create_table "artist_sources", force: :cascade do |t|
    t.string "source_id"
    t.string "source"
    t.bigint "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_artist_sources_on_artist_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "img_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.bigint "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_genres_on_album_id"
  end

  add_foreign_key "album_sources", "albums"
  add_foreign_key "artist_sources", "artists"
  add_foreign_key "genres", "albums"
end
