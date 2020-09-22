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

ActiveRecord::Schema.define(version: 2020_09_22_025557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "routines", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "skip_day"
    t.boolean "progress_display", default: true, null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_routines_on_user_id"
  end

  create_table "shortcuts", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_shortcuts_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.boolean "status", default: false, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "date_id"
    t.bigint "routine_id"
    t.index ["routine_id"], name: "index_tasks_on_routine_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "routines", "users"
  add_foreign_key "shortcuts", "users"
  add_foreign_key "tasks", "routines"
end
