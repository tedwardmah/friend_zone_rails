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

ActiveRecord::Schema.define(version: 20160119012737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archives", force: true do |t|
    t.string   "name"
    t.string   "spotify_uri"
    t.string   "snapshot_id"
    t.string   "collaboration_name"
    t.string   "year"
    t.string   "month"
    t.integer  "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_master"
    t.string   "frequency"
  end

  create_table "backups", force: true do |t|
    t.string   "name"
    t.string   "spotify_uri"
    t.string   "snapshot_id"
    t.string   "collaboration_name"
    t.string   "year"
    t.string   "month"
    t.boolean  "is_archive_backup"
    t.integer  "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", force: true do |t|
    t.string   "spotify_uri"
    t.string   "snapshot_id"
    t.string   "collaboration_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "rolloff_frequency"
    t.string   "owner"
    t.boolean  "repeats_allowed"
  end

  create_table "songs", force: true do |t|
    t.string   "spotify_uri"
    t.string   "added_by_uri"
    t.string   "added_by_username"
    t.string   "added_on"
    t.integer  "user_id"
    t.integer  "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "archive_id"
    t.integer  "backup_id"
  end

  create_table "users", force: true do |t|
    t.string   "spotify_user_id"
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
