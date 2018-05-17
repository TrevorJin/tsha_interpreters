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

ActiveRecord::Schema.define(version: 20180516155544) do

  create_table "appointments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "user_id"], name: "index_appointments_on_job_id_and_user_id", unique: true
    t.index ["job_id"], name: "index_appointments_on_job_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

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
    t.integer  "tsha_number"
    t.integer  "fund_number"
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "interpreter_invoices", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.string   "job_type"
    t.string   "event_location_address_line_1"
    t.string   "event_location_address_line_2"
    t.string   "event_location_address_line_3"
    t.string   "contact_person_first_name"
    t.string   "contact_person_last_name"
    t.string   "contact_person_phone_number"
    t.text     "interpreter_comments"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "user_id"
    t.integer  "job_id"
    t.decimal  "miles"
    t.decimal  "mile_rate"
    t.decimal  "interpreting_hours"
    t.decimal  "interpreting_rate"
    t.decimal  "extra_miles"
    t.decimal  "extra_mile_rate"
    t.decimal  "extra_interpreting_hours"
    t.decimal  "extra_interpreting_rate"
    t.boolean  "job_completed",                 default: false
    t.datetime "job_completed_at"
    t.index ["job_id"], name: "index_interpreter_invoices_on_job_id"
    t.index ["user_id"], name: "index_interpreter_invoices_on_user_id"
  end

  create_table "interpreting_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_interpreting_requests_on_job_id"
    t.index ["user_id", "job_id"], name: "index_interpreting_requests_on_user_id_and_job_id", unique: true
    t.index ["user_id"], name: "index_interpreting_requests_on_user_id"
  end

  create_table "job_completions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_completions_on_job_id"
    t.index ["user_id", "job_id"], name: "index_job_completions_on_user_id_and_job_id", unique: true
    t.index ["user_id"], name: "index_job_completions_on_user_id"
  end

  create_table "job_rejections", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_rejections_on_job_id"
    t.index ["user_id", "job_id"], name: "index_job_rejections_on_user_id_and_job_id", unique: true
    t.index ["user_id"], name: "index_job_rejections_on_user_id"
  end

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
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "customer_id"
    t.boolean  "awaiting_approval",             default: true
    t.boolean  "accepted",                      default: false
    t.datetime "accepted_at"
    t.boolean  "denied",                        default: false
    t.datetime "denied_at"
    t.boolean  "expired",                       default: false
    t.datetime "expired_at"
    t.index ["customer_id"], name: "index_job_requests_on_customer_id"
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
    t.boolean  "has_interpreter_assigned",                 default: false
    t.boolean  "bei_required",                             default: false
    t.boolean  "bei_advanced_required",                    default: false
    t.boolean  "bei_master_required",                      default: false
    t.boolean  "expired",                                  default: false
    t.datetime "expired_at"
    t.string   "requester_first_name"
    t.string   "requester_last_name"
    t.string   "requester_email"
    t.string   "requester_phone_number"
    t.string   "contact_person_first_name"
    t.string   "contact_person_last_name"
    t.boolean  "invoice_submitted",                        default: false
    t.datetime "invoice_submitted_at"
    t.datetime "has_interpreter_assigned_at"
    t.boolean  "completed",                                default: false
    t.datetime "completed_at"
    t.index ["customer_id"], name: "index_jobs_on_customer_id"
  end

  create_table "manager_invoices", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.string   "job_type"
    t.string   "event_location_address_line_1"
    t.string   "event_location_address_line_2"
    t.string   "event_location_address_line_3"
    t.string   "contact_person_first_name"
    t.string   "contact_person_last_name"
    t.string   "contact_person_phone_number"
    t.text     "interpreter_comments"
    t.decimal  "miles"
    t.decimal  "mile_rate"
    t.decimal  "interpreting_hours"
    t.decimal  "interpreting_rate"
    t.decimal  "extra_miles"
    t.decimal  "extra_mile_rate"
    t.decimal  "extra_interpreting_hours"
    t.decimal  "extra_interpreting_rate"
    t.boolean  "job_completed",                 default: false
    t.datetime "job_completed_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "user_id"
    t.integer  "job_id"
    t.integer  "interpreter_invoice_id"
    t.boolean  "customer_approved",             default: false
    t.datetime "customer_approved_at"
    t.index ["interpreter_invoice_id"], name: "index_manager_invoices_on_interpreter_invoice_id"
    t.index ["job_id"], name: "index_manager_invoices_on_job_id"
    t.index ["user_id"], name: "index_manager_invoices_on_user_id"
  end

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
    t.boolean  "bei",                               default: false
    t.boolean  "bei_advanced",                      default: false
    t.boolean  "bei_master",                        default: false
    t.integer  "vendor_number"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
