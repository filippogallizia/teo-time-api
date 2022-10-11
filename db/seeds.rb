require 'factory_bot_rails'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['client', 'trainer', 'admin', 'blocked'].each do |role|
  Role.find_or_create_by({ name: role })
end

['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'].each do |day|
  Day.find_or_create_by({ name: day })
end

WeeklyAvailability.find_or_create_by({ name: 'default weekly availability' })

[1, 2, 3, 4, 5, 6, 7].each do |day|
  Hour.find_or_create_by({ start: 480, end: 720, weekly_availability_id: 1, day_id: day, time_zone: 'Europe/Berlin' })
  Hour.find_or_create_by({ start: 780, end: 1200, weekly_availability_id: 1, day_id: day, time_zone: 'Europe/Berlin' })
end

Event.find_or_create_by({ name: 'osteopathic' })