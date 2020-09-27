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

ActiveRecord::Schema.define(version: 2020_09_27_025537) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "routines", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", null: false
    t.text "body"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.text "skip_days", default: [], array: true
    t.boolean "progress_display", default: true, null: false
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

  create_table "todos", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.date "todo_date", null: false
    t.boolean "status", default: false, null: false
    t.integer "user_id", null: false
    t.integer "routine_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "routines", "users"
  add_foreign_key "shortcuts", "users"
end
