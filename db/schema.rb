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

ActiveRecord::Schema.define(version: 20160404052944) do

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
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
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
    t.string   "password_digest"
    t.string   "activation_digest"
    t.boolean  "activated",                      default: false
    t.datetime "activated_at"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "approved",                       default: false
    t.datetime "approved_at"
    t.boolean  "active",                         default: true
  end

  add_index "customers", ["email"], name: "index_customers_on_email", unique: true

  create_table "job_requests", force: :cascade do |t|
    t.string   "requester_first_name"
    t.string   "requester_last_name"
    t.string   "office_business_name"
    t.string   "requester_email"
    t.string   "requester_phone_number"
    t.string   "requester_fax_number"
    t.datetime "start"
    t.datetime "end"
    t.string   "deaf_client_first_name"
    t.string   "deaf_client_last_name"
    t.string   "contact_person_first_name"
    t.string   "contact_person_last_name"
    t.string   "event_location_address_line_1"
    t.string   "event_location_address_line_2"
    t.string   "event_location_address_line_3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "office_phone_number"
    t.text     "type_of_appointment_situation"
    t.text     "message"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "customer_id"
  end

  add_index "job_requests", ["customer_id"], name: "index_job_requests_on_customer_id"

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
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "customer_id"
    t.boolean  "qast_1_interpreting_required",             default: false
    t.boolean  "qast_2_interpreting_required",             default: false
    t.boolean  "qast_3_interpreting_required",             default: false
    t.boolean  "qast_4_interpreting_required",             default: false
    t.boolean  "qast_5_interpreting_required",             default: false
    t.boolean  "qast_1_transliterating_required_required", default: false
    t.boolean  "qast_2_transliterating_required",          default: false
    t.boolean  "qast_3_transliterating_required",          default: false
    t.boolean  "qast_4_transliterating_required",          default: false
    t.boolean  "qast_5_transliterating_required",          default: false
    t.boolean  "rid_ci_required",                          default: false
    t.boolean  "rid_ct_required",                          default: false
    t.boolean  "rid_cdi_required",                         default: false
    t.boolean  "di_required",                              default: false
    t.boolean  "nic_required",                             default: false
    t.boolean  "nic_advanced_required",                    default: false
    t.boolean  "nic_master_required",                      default: false
    t.boolean  "rid_sc_l_required",                        default: false
  end

  add_index "jobs", ["customer_id"], name: "index_jobs_on_customer_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                             default: false
    t.string   "activation_digest"
    t.boolean  "activated",                         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "cell_phone",             limit: 30
    t.boolean  "manager",                           default: false
    t.boolean  "approved",                          default: false
    t.datetime "approved_at"
    t.boolean  "qast_1_interpreting",               default: false
    t.boolean  "qast_2_interpreting",               default: false
    t.boolean  "qast_3_interpreting",               default: false
    t.boolean  "qast_4_interpreting",               default: false
    t.boolean  "qast_5_interpreting",               default: false
    t.boolean  "qast_1_transliterating",            default: false
    t.boolean  "qast_2_transliterating",            default: false
    t.boolean  "qast_3_transliterating",            default: false
    t.boolean  "qast_4_transliterating",            default: false
    t.boolean  "qast_5_transliterating",            default: false
    t.boolean  "rid_ci",                            default: false
    t.boolean  "rid_ct",                            default: false
    t.boolean  "rid_cdi",                           default: false
    t.boolean  "di",                                default: false
    t.boolean  "nic",                               default: false
    t.boolean  "nic_advanced",                      default: false
    t.boolean  "nic_master",                        default: false
    t.boolean  "rid_sc_l",                          default: false
    t.boolean  "active",                            default: true
    t.string   "gender"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
