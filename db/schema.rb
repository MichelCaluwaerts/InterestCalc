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

ActiveRecord::Schema.define(version: 2022_06_18_195050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "int_type"
    t.float "total"
    t.float "percentage"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "switch_date"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "capitalisations", force: :cascade do |t|
    t.date "date"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_capitalisations_on_account_id"
  end

  create_table "costs", force: :cascade do |t|
    t.string "description"
    t.date "date"
    t.float "amount"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_costs_on_account_id"
  end

  create_table "credits", force: :cascade do |t|
    t.string "description"
    t.date "date"
    t.float "amount"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_credits_on_account_id"
  end

  create_table "payments", force: :cascade do |t|
    t.date "date"
    t.float "amount"
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_payments_on_account_id"
  end

  create_table "periods", force: :cascade do |t|
    t.date "date"
    t.date "date_fin"
    t.bigint "account_id", null: false
    t.bigint "rate_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_periods_on_account_id"
    t.index ["rate_id"], name: "index_periods_on_rate_id"
  end

  create_table "rates", force: :cascade do |t|
    t.date "date"
    t.date "date_fin"
    t.float "pct"
    t.string "int_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "switch_date"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "capitalisations", "accounts"
  add_foreign_key "costs", "accounts"
  add_foreign_key "credits", "accounts"
  add_foreign_key "payments", "accounts"
  add_foreign_key "periods", "accounts"
  add_foreign_key "periods", "rates"
end
