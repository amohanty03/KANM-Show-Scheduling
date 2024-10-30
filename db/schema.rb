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

ActiveRecord::Schema[7.2].define(version: 2024_10_29_201112) do
  create_table "admins", force: :cascade do |t|
    t.string "email"
    t.string "uin"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
  end

  create_table "radio_jockeys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "show_name"
    t.string "timestamp"
    t.string "UIN"
    t.string "expected_grad"
    t.string "member_type"
    t.string "retaining"
    t.string "semesters_in_KANM"
    t.string "DJ_name"
    t.string "best_day"
    t.string "best_hour"
    t.string "alt_mon"
    t.string "alt_tue"
    t.string "alt_wed"
    t.string "alt_thu"
    t.string "alt_fri"
    t.string "alt_sat"
    t.string "alt_sun"
    t.string "un_jan"
    t.string "un_feb"
    t.string "un_mar"
    t.string "un_apr"
    t.string "un_may"
  end

  create_table "schedule_entries", force: :cascade do |t|
    t.string "day"
    t.integer "hour"
    t.string "show_name"
    t.string "last_name"
    t.integer "jockey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
