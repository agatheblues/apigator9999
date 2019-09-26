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

ActiveRecord::Schema.define(version: 2019_09_11_151453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", primary_key: ["spotify_id", "discogs_id"], force: :cascade do |t|
    t.datetime "added_at", null: false
    t.string "name", null: false
    t.string "release_date"
    t.string "spotify_id", null: false
    t.string "discogs_id", null: false
    t.integer "total_tracks"
    t.string "img_url"
    t.integer "img_height"
    t.integer "img_width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "albums_artists", id: false, force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "album_id", null: false
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "img_url"
    t.string "spotify_id"
    t.string "discogs_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
