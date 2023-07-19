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

ActiveRecord::Schema[7.0].define(version: 2023_07_19_100549) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "absence"
    t.boolean "arrived_late"
    t.boolean "worked_too_short"
    t.boolean "finished_too_early"
    t.boolean "incomplete_assistances"
    t.datetime "day"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "assistances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "happened_at"
    t.integer "kind"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_assistances_on_user_id"
  end

  create_table "demo_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone_number"
    t.string "company_name"
    t.string "company_website"
    t.string "how_did_you_hear_about_us"
    t.integer "status", default: 0
    t.datetime "scheduled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "organization_id"
    t.string "slug"
    t.index ["name"], name: "index_departments_on_name", unique: true
    t.index ["organization_id"], name: "index_departments_on_organization_id"
  end

  create_table "departments_users", id: false, force: :cascade do |t|
    t.uuid "department_id", null: false
    t.uuid "user_id", null: false
    t.index ["department_id", "user_id"], name: "index_departments_users_on_department_id_and_user_id"
    t.index ["user_id", "department_id"], name: "index_departments_users_on_user_id_and_department_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "organization_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "positions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "department_id"
    t.index ["department_id"], name: "index_positions_on_department_id"
    t.index ["name"], name: "index_positions_on_name", unique: true
  end

  create_table "salaries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.date "date"
    t.uuid "user_id", null: false
    t.uuid "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_salaries_on_organization_id"
    t.index ["user_id"], name: "index_salaries_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.string "avatar"
    t.string "username"
    t.text "bio"
    t.integer "role", default: 0
    t.boolean "is_admin", default: false
    t.integer "salary", default: 0
    t.string "country", default: "Kenya"
    t.string "city", default: "Nairobi"
    t.string "phone_number", default: ""
    t.string "zip", default: ""
    t.uuid "organization_id"
    t.datetime "reset_password_token_expires_at"
    t.integer "age"
    t.string "address"
    t.string "nationality"
    t.string "employee_numero"
    t.date "employment_date"
    t.string "personal_email"
    t.string "marital_status"
    t.string "gender"
    t.string "national_id"
    t.date "date_of_birth"
    t.string "length_of_service"
    t.integer "status", default: 0
    t.string "level_of_education"
    t.string "field_of_study"
    t.string "university"
    t.boolean "is_company_owner", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_days", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "day"
    t.float "total_hours"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_work_days_on_user_id"
  end

  add_foreign_key "activities", "users"
  add_foreign_key "assistances", "users"
  add_foreign_key "departments", "organizations"
  add_foreign_key "positions", "departments"
  add_foreign_key "salaries", "organizations"
  add_foreign_key "salaries", "users"
  add_foreign_key "users", "organizations"
  add_foreign_key "work_days", "users"
end
