# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users (Interpreters, Managers, and Admins)

# Admin

User.create!(first_name:  "Example",
						 last_name:  "Admin",
             gender: "Male",
             cell_phone: "+18662466453",
             email: "admin@tsha.cc",
             password:              "foobar",
             password_confirmation: "foobar",
             manager: true,
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             approved: true,
             approved_at: Time.zone.now,
             active: true,
             qast_1_interpreting: true,
             qast_2_interpreting: true,
             qast_3_interpreting: true,
             qast_4_interpreting: true,
             qast_5_interpreting: true,
             qast_1_transliterating: true,
             qast_2_transliterating: true,
             qast_3_transliterating: true,
             qast_4_transliterating: true,
             qast_5_transliterating: true,
             rid_ci: true,
             rid_ct: true,
             rid_cdi: true,
             di: true,
             nic: true,
             nic_advanced: true,
             nic_master: true,
             rid_sc_l: true)

# Manager

User.create!(first_name:  "Example",
             last_name:  "Manager",
             gender: "Male",
             cell_phone: "+18662466453",
             email: "manager@tsha.cc",
             password:              "foobar",
             password_confirmation: "foobar",
             manager: true,
             activated: true,
             activated_at: Time.zone.now,
             approved: true,
             approved_at: Time.zone.now,
             active: true,
             qast_1_interpreting: true,
             qast_2_interpreting: true,
             qast_3_interpreting: true,
             qast_4_interpreting: true,
             qast_5_interpreting: true,
             qast_1_transliterating: true,
             qast_2_transliterating: true,
             qast_3_transliterating: true,
             qast_4_transliterating: true,
             qast_5_transliterating: true,
             rid_ci: true,
             rid_ct: true,
             rid_cdi: true,
             di: true,
             nic: true,
             nic_advanced: true,
             nic_master: true,
             rid_sc_l: true)

User.create!(first_name: "Rene'",
             last_name:  "Ryan",
             gender: "Female",
             cell_phone: "+18662466453",
             email: "rryan@tsha.cc",
             password: "foobar",
             password_confirmation: "foobar",
             manager: true,
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             approved: true,
             approved_at: Time.zone.now,
             active: true,
             qast_1_interpreting: true,
             qast_2_interpreting: true,
             qast_3_interpreting: true,
             qast_4_interpreting: true,
             qast_5_interpreting: true,
             qast_1_transliterating: true,
             qast_2_transliterating: true,
             qast_3_transliterating: true,
             qast_4_transliterating: true,
             qast_5_transliterating: true,
             rid_ci: true,
             rid_ct: true,
             rid_cdi: true,
             di: true,
             nic: true,
             nic_advanced: true,
             nic_master: true,
             rid_sc_l: true)

User.create!(first_name: "Linda",
             last_name:  "Hawkins",
             gender: "Female",
             cell_phone: "+18662466453",
             email: "lhawkins@tsha.cc",
             password: "foobar",
             password_confirmation: "foobar",
             manager: true,
             activated: true,
             activated_at: Time.zone.now,
             approved: true,
             approved_at: Time.zone.now,
             active: true,
             qast_1_interpreting: true,
             qast_2_interpreting: true,
             qast_3_interpreting: true,
             qast_4_interpreting: true,
             qast_5_interpreting: true,
             qast_1_transliterating: true,
             qast_2_transliterating: true,
             qast_3_transliterating: true,
             qast_4_transliterating: true,
             qast_5_transliterating: true,
             rid_ci: true,
             rid_ct: true,
             rid_cdi: true,
             di: true,
             nic: true,
             nic_advanced: true,
             nic_master: true,
             rid_sc_l: true)

User.create!(first_name: "Angie",
             last_name:  "Davis",
             gender: "Female",
             cell_phone: "+18662466453",
             email: "adavis@tsha.cc",
             password: "foobar",
             password_confirmation: "foobar",
             manager: true,
             activated: true,
             activated_at: Time.zone.now,
             approved: true,
             approved_at: Time.zone.now,
             active: true,
             qast_1_interpreting: true,
             qast_2_interpreting: true,
             qast_3_interpreting: true,
             qast_4_interpreting: true,
             qast_5_interpreting: true,
             qast_1_transliterating: true,
             qast_2_transliterating: true,
             qast_3_transliterating: true,
             qast_4_transliterating: true,
             qast_5_transliterating: true,
             rid_ci: true,
             rid_ct: true,
             rid_cdi: true,
             di: true,
             nic: true,
             nic_advanced: true,
             nic_master: true,
             rid_sc_l: true)

User.create!(first_name: "Yamileth",
             last_name:  "Canales",
             gender: "Female",
             cell_phone: "+18662466453",
             email: "ycanales@tsha.cc",
             password: "foobar",
             password_confirmation: "foobar",
             manager: true,
             activated: true,
             activated_at: Time.zone.now,
             approved: true,
             approved_at: Time.zone.now,
             active: true,
             qast_1_interpreting: true,
             qast_2_interpreting: true,
             qast_3_interpreting: true,
             qast_4_interpreting: true,
             qast_5_interpreting: true,
             qast_1_transliterating: true,
             qast_2_transliterating: true,
             qast_3_transliterating: true,
             qast_4_transliterating: true,
             qast_5_transliterating: true,
             rid_ci: true,
             rid_ct: true,
             rid_cdi: true,
             di: true,
             nic: true,
             nic_advanced: true,
             nic_master: true,
             rid_sc_l: true)

User.create!(first_name: "Sammy",
             last_name:  "Flake",
             gender: "Male",
             cell_phone: "+18662466453",
             email: "sammyflake@yahoo.com",
             password: "foobar",
             password_confirmation: "foobar",
             activated: true,
             activated_at: Time.zone.now,
             active: true,
             qast_1_interpreting: true,
             qast_2_interpreting: true,
             qast_3_interpreting: true,
             qast_4_interpreting: true,
             qast_5_interpreting: true,
             qast_1_transliterating: true,
             qast_2_transliterating: true,
             qast_3_transliterating: true,
             qast_4_transliterating: true,
             qast_5_transliterating: true,
             rid_ci: true,
             rid_ct: true,
             rid_cdi: true,
             di: true,
             nic: true,
             nic_advanced: true,
             nic_master: true,
             rid_sc_l: true)

99.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  gender_boolean = Faker::Boolean.boolean
  if gender_boolean
    gender = "Male"
  else
    gender = "Female"
  end
  email = Faker::Internet.free_email("#{first_name}#{last_name}")
  User.create!(first_name:  first_name,
  						 last_name:  last_name,
               gender: gender,
               cell_phone: "+18662466453",
               email: email,
               password:              "password",
               password_confirmation: "password",
               activated: true,
               activated_at: Time.zone.now,
               approved: true,
               approved_at: Time.zone.now,
               active: true,
               qast_1_interpreting: true,
               qast_2_interpreting: true,
               qast_3_interpreting: true,
               qast_4_interpreting: true,
               qast_5_interpreting: true,
               qast_1_transliterating: true,
               qast_2_transliterating: true,
               qast_3_transliterating: true,
               qast_4_transliterating: true,
               qast_5_transliterating: true,
               rid_ci: true,
               rid_ct: true,
               rid_cdi: true,
               di: true,
               nic: true,
               nic_advanced: true,
               nic_master: true,
               rid_sc_l: true)
end

# Pending Interpreters

17.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  gender_boolean = Faker::Boolean.boolean
  if gender_boolean
    gender = "Male"
  else
    gender = "Female"
  end
  email = Faker::Internet.free_email("#{first_name}#{last_name}")
  User.create!(first_name:  first_name,
               last_name:  last_name,
               gender: gender,
               cell_phone: "+18662466453",
               email: email,
               password:              "password",
               password_confirmation: "password",
               activated: true,
               activated_at: Time.zone.now,
               approved: false,
               approved_at: "",
               qast_1_interpreting: true,
               qast_2_interpreting: true,
               qast_3_interpreting: true,
               qast_4_interpreting: true,
               qast_5_interpreting: true,
               qast_1_transliterating: true,
               qast_2_transliterating: true,
               qast_3_transliterating: true,
               qast_4_transliterating: true,
               qast_5_transliterating: true,
               rid_ci: true,
               rid_ct: true,
               rid_cdi: true,
               di: true,
               nic: true,
               nic_advanced: true,
               nic_master: true,
               rid_sc_l: true)
end

# Customers

Customer.create!(customer_name:  "University of Tulsa",
                 contact_first_name:  "John",
                 contact_last_name: "Smith",
                 contact_phone_number: "+18662466453",
                 contact_phone_number_extension: "123",
                 phone_number: "+18662466453",
                 phone_number_extension: "",
                 email: "admission@utulsa.edu",
                 fax: "918-631-5003",
                 billing_address_line_1: "Collins Hall",
                 billing_address_line_2: "The University of Tulsa",
                 billing_address_line_3: "800 South Tucker Drive",
                 mail_address_line_1: "Collins Hall",
                 mail_address_line_2: "The University of Tulsa",
                 mail_address_line_3: "800 South Tucker Drive",
                 activated: true,
                 activated_at: Time.zone.now,
                 approved: true,
                 approved_at: Time.zone.now)

Customer.create!(customer_name:  "Hideaway Pizza",
                 contact_first_name:  "Harry",
                 contact_last_name: "Hideaway",
                 contact_phone_number: "+18662466453",
                 contact_phone_number_extension: "123",
                 phone_number: "+18662466453",
                 phone_number_extension: "",
                 email: "letseatsomepizza@hideawaypizza.com",
                 fax: "",
                 billing_address_line_1: "Hideaway-2, Inc.",
                 billing_address_line_2: "1631 S. Boston Ave.",
                 billing_address_line_3: "Tulsa, OK 74119",
                 mail_address_line_1: "Hideaway-2, Inc.",
                 mail_address_line_2: "1631 S. Boston Ave.",
                 mail_address_line_3: "Tulsa, OK 74119",
                 activated: true,
                 activated_at: Time.zone.now,
                 approved: true,
                 approved_at: Time.zone.now)

30.times do |n|
  customer_name  = Faker::Company.name
  contact_first_name = Faker::Name.first_name
  contact_last_name  = Faker::Name.last_name
  email = Faker::Internet.free_email("#{contact_first_name}#{contact_last_name}")
  address_line_1 = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state
  zip_code = Faker::Address.zip_code
  address_line_2 = "#{city}, #{state} #{zip_code}"
  Customer.create!(customer_name:  customer_name,
                   contact_first_name:  contact_first_name,
                   contact_last_name:  contact_last_name,
                   contact_phone_number: "+18662466453",
                   contact_phone_number_extension: "123",
                   phone_number: "+18662466453",
                   phone_number_extension: "",
                   email: email,
                   fax: "",
                   billing_address_line_1: address_line_1,
                   billing_address_line_2: address_line_2,
                   billing_address_line_3: "",
                   mail_address_line_1: address_line_1,
                   mail_address_line_2: address_line_2,
                   mail_address_line_3: "",
                   activated: true,
                   activated_at: Time.zone.now,
                   approved: true,
                   approved_at: Time.zone.now)
end

# Pending Customers

7.times do |n|
  customer_name  = Faker::Company.name
  contact_first_name = Faker::Name.first_name
  contact_last_name  = Faker::Name.last_name
  email = Faker::Internet.free_email("#{contact_first_name}#{contact_last_name}")
  address_line_1 = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state
  zip_code = Faker::Address.zip_code
  address_line_2 = "#{city}, #{state} #{zip_code}"
  Customer.create!(customer_name:  customer_name,
                   contact_first_name:  contact_first_name,
                   contact_last_name:  contact_last_name,
                   contact_phone_number: "+18662466453",
                   contact_phone_number_extension: "123",
                   phone_number: "+18662466453",
                   phone_number_extension: "",
                   email: email,
                   fax: "",
                   billing_address_line_1: address_line_1,
                   billing_address_line_2: address_line_2,
                   billing_address_line_3: "",
                   mail_address_line_1: address_line_1,
                   mail_address_line_2: address_line_2,
                   mail_address_line_3: "",
                   activated: true,
                   activated_at: Time.zone.now,
                   approved: false,
                   approved_at: "")
end
