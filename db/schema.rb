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

ActiveRecord::Schema.define(version: 2022_10_10_143026) do

  create_table "bookings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.integer "calendarEventId"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "event_id"
    t.bigint "weekly_availability_id"
    t.bigint "trainer_id"
    t.string "time_zone"
    t.index ["event_id"], name: "index_bookings_on_event_id"
    t.index ["trainer_id"], name: "index_bookings_on_trainer_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
    t.index ["weekly_availability_id"], name: "index_bookings_on_weekly_availability_id"
  end

  create_table "days", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "string"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "weekly_availability_id"
    t.bigint "user_id"
    t.integer "duration"
    t.integer "increment_amount"
    t.index ["user_id"], name: "index_events_on_user_id"
    t.index ["weekly_availability_id"], name: "index_events_on_weekly_availability_id"
  end

  create_table "hours", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "start"
    t.integer "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "weekly_availability_id"
    t.bigint "day_id"
    t.string "time_zone"
    t.index ["day_id"], name: "index_hours_on_day_id"
    t.index ["weekly_availability_id"], name: "index_hours_on_weekly_availability_id"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "weekly_availabilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "users"
  add_foreign_key "bookings", "users", column: "trainer_id"
  add_foreign_key "events", "users"
  add_foreign_key "events", "weekly_availabilities"
  add_foreign_key "users", "roles"
end
