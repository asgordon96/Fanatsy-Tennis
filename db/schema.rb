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

ActiveRecord::Schema.define(version: 20130903001655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drafts", force: true do |t|
    t.string   "order"
    t.string   "player"
    t.integer  "bid"
    t.integer  "nominator"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_team_id"
    t.integer  "league_id"
    t.boolean  "completed"
  end

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.datetime "draft_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num_teams"
    t.integer  "players_per_team"
  end

  create_table "players", force: true do |t|
    t.integer  "rank"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "atp_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_name"
    t.string   "name"
    t.string   "country"
  end

  create_table "players_teams", force: true do |t|
    t.integer "player_id"
    t.integer "team_id"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_points"
    t.integer  "league_id"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
  end

end
