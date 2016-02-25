# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160225140314) do

  create_table "appointments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "appointments", ["job_id"], name: "index_appointments_on_job_id"
  add_index "appointments", ["user_id"], name: "index_appointments_on_user_id"

  create_table "customers", force: :cascade do |t|
    t.string   "contact_first_name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "contact_last_name"
    t.string   "billing_address_line_1"
    t.string   "billing_address_line_2"
    t.string   "billing_address_line_3"
    t.string   "mail_address_line_1"
    t.string   "mail_address_line_2"
    t.string   "mail_address_line_3"
    t.string   "customer_name"
    t.string   "phone_number"
    t.string   "phone_number_extension"
    t.string   "contact_phone_number"
    t.string   "contact_phone_number_extension"
    t.string   "email"
    t.string   "fax"
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.text     "invoice_notes"
    t.text     "notes_for_irp"
    t.text     "notes_for_interpreter"
    t.text     "directions"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                        default: false
    t.string   "activation_digest"
    t.boolean  "activated",                    default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "cell_phone",        limit: 30
    t.boolean  "manager",                      default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
