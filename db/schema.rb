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

ActiveRecord::Schema.define(version: 2019_07_13_153752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'import_statuses',
               id: :uuid,
               default: -> { 'gen_random_uuid()' },
               force: :cascade do |t|
    t.string 'key', null: false
    t.date 'date', null: false
    t.datetime 'imported_at'
    t.jsonb 'data'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[key], name: 'index_import_statuses_on_key'
  end

  create_table 'stats',
               id: :uuid,
               default: -> { 'gen_random_uuid()' },
               force: :cascade do |t|
    t.date 'date', null: false
    t.string 'key', null: false
    t.string 'value', null: false
    t.integer 'count', default: 0, null: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.index %w[date key value],
            name: 'index_stats_on_date_and_key_and_value', unique: true
  end
end
