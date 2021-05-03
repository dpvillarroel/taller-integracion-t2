# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_27_043555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", id: :string, force: :cascade do |t|
    t.string "artist_id", null: false
    t.string "name"
    t.string "genre"
    t.string "artist_url"
    t.string "tracks_url"
    t.string "self_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
  end

  create_table "artists", id: :string, force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "albums_url"
    t.string "tracks_url"
    t.string "self_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tracks", id: :string, force: :cascade do |t|
    t.string "album_id", null: false
    t.string "name"
    t.float "duration"
    t.integer "times_played"
    t.string "artist_url"
    t.string "album_url"
    t.string "self_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
  end

  add_foreign_key "albums", "artists"
  add_foreign_key "tracks", "albums"
end
