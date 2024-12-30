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

ActiveRecord::Schema[7.1].define(version: 2024_12_30_081714) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "aircrafts", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "registration", null: false
    t.string "model", null: false
    t.integer "capacity", null: false
    t.date "manufacture_date", null: false
    t.integer "range_nm", null: false
    t.string "owner_id", limit: 26, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_aircrafts_on_owner_id"
    t.index ["registration"], name: "index_aircrafts_on_registration", unique: true
  end

  create_table "bookings", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.integer "status"
    t.datetime "booking_date"
    t.string "flight_id", limit: 26, null: false
    t.string "user_id", limit: 26, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_id"], name: "index_bookings_on_flight_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "capabilities", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_capabilities_on_name", unique: true
  end

  create_table "flights", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "origin"
    t.string "destination"
    t.datetime "departure_time"
    t.datetime "estimated_arrival_time"
    t.datetime "actual_departure_time"
    t.datetime "actual_arrival_time"
    t.integer "status"
    t.integer "capacity"
    t.string "pilot_id", limit: 26, null: false
    t.string "aircraft_id", limit: 26, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aircraft_id"], name: "index_flights_on_aircraft_id"
    t.index ["pilot_id"], name: "index_flights_on_pilot_id"
  end

  create_table "user_capabilities", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "user_id", limit: 26, null: false
    t.string "capability_id", limit: 26, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capability_id"], name: "index_user_capabilities_on_capability_id"
    t.index ["user_id", "capability_id"], name: "index_user_capabilities_on_user_id_and_capability_id", unique: true
    t.index ["user_id"], name: "index_user_capabilities_on_user_id"
  end

  create_table "users", id: { type: :string, limit: 26 }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "avatar_url"
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "capabilities_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "aircrafts", "users", column: "owner_id"
  add_foreign_key "bookings", "flights"
  add_foreign_key "bookings", "users"
  add_foreign_key "flights", "aircrafts"
  add_foreign_key "flights", "users", column: "pilot_id"
  add_foreign_key "user_capabilities", "capabilities"
  add_foreign_key "user_capabilities", "users"
end
