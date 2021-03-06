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

ActiveRecord::Schema.define(version: 2020_05_05_150100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.datetime "added_at", null: false
    t.string "name", null: false
    t.string "release_date"
    t.string "spotify_id"
    t.string "discogs_id"
    t.integer "total_tracks"
    t.string "img_url"
    t.integer "img_height"
    t.integer "img_width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "youtube_url"
    t.string "bandcamp_url"
    t.index ["discogs_id"], name: "index_albums_on_discogs_id", unique: true
    t.index ["spotify_id"], name: "index_albums_on_spotify_id", unique: true
  end

  create_table "albums_artists", id: false, force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "album_id", null: false
  end

  create_table "albums_genres", id: false, force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "genre_id", null: false
  end

  create_table "albums_styles", id: false, force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "style_id", null: false
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "img_url"
    t.string "spotify_id"
    t.string "discogs_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_tracks", default: 0
    t.integer "total_albums", default: 0
    t.index ["discogs_id"], name: "index_artists_on_discogs_id", unique: true
    t.index ["spotify_id"], name: "index_artists_on_spotify_id", unique: true
  end

  create_table "batches", force: :cascade do |t|
    t.jsonb "data", default: "{}", null: false
    t.string "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_batches_on_job_id", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_albums", default: 0
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "styles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_albums", default: 0
    t.index ["name"], name: "index_styles_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "role", default: "user", null: false
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
