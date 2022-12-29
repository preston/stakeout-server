# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dashboards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_dashboards_on_name", unique: true
  end

  create_table "services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "dashboard_id"
    t.string "name", null: false
    t.string "host", null: false
    t.boolean "ping", default: true
    t.integer "ping_threshold", default: 500
    t.integer "ping_last"
    t.boolean "http", default: true
    t.boolean "https", default: false
    t.string "http_path", default: "", null: false
    t.boolean "http_path_last", default: false
    t.boolean "https_path_last", default: false
    t.string "http_xquery"
    t.boolean "http_xquery_last", default: false
    t.boolean "http_preview", default: true
    t.binary "http_screenshot"
    t.datetime "checked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id", "name"], name: "index_services_on_dashboard_id_and_name", unique: true
  end

end
