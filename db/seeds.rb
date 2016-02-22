# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(first_name:  "Example",
						 last_name:  "Admin",
             cell_phone: "1234567890",
             email: "admin@tsha.cc",
             password:              "foobar",
             password_confirmation: "foobar",
             manager: true,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name:  "Example",
             last_name:  "Manager",
             cell_phone: "1234567890",
             email: "manager@tsha.cc",
             password:              "foobar",
             password_confirmation: "foobar",
             manager: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name: "Rene'",
             last_name:  "Ryan",
             cell_phone: "1234567890",
             email: "rryan@tsha.cc",
             password: "foobar",
             password_confirmation: "foobar",
             manager: true,
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name: "Linda",
             last_name:  "Hawkins",
             cell_phone: "1234567890",
             email: "lhawkins@tsha.cc",
             password: "foobar",
             password_confirmation: "foobar",
             manager: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name: "Angie",
             last_name:  "Davis",
             cell_phone: "1234567890",
             email: "adavis@tsha.cc",
             password: "foobar",
             password_confirmation: "foobar",
             manager: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(first_name: "Yamileth",
             last_name:  "Canales",
             cell_phone: "1234567890",
             email: "ycanales@tsha.cc",
             password: "foobar",
             password_confirmation: "foobar",
             manager: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  first_name  = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  cell_phone = "#{n}#{n}#{n}#{n}#{n}#{n}#{n}#{n}#{n}#{n}"
  email = "example-#{n+1}@tsha.cc"
  password = "password"
  User.create!(first_name:  first_name,
  						 last_name:  last_name,
               cell_phone: cell_phone,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
