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

ActiveRecord::Schema.define(version: 20170628145708) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.integer  "rows",          default: 6
    t.integer  "columns",       default: 7
    t.string   "winner"
    t.integer  "players_count", default: 2
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "picks", force: :cascade do |t|
    t.integer  "board_id"
    t.integer  "player_id"
    t.integer  "row"
    t.integer  "column"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id", "row", "column"], name: "index_picks_on_board_row_column", using: :btree
    t.index ["board_id"], name: "index_picks_on_board_id", using: :btree
    t.index ["player_id"], name: "index_picks_on_player_id", using: :btree
    t.index ["row", "column"], name: "index_picks_on_row_column", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.integer  "board_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_player_on_board_id", using: :btree
    t.index ["board_id"], name: "index_players_on_board_id", using: :btree
  end

end
