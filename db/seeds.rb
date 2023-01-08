require 'factory_bot_rails'

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
