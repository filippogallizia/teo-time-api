# run this command to run chronojob:  bundle exec whenever --update-crontab
every 1.day, at: '12:00 am' do
  command "cd #{path} && bundle exec rails runner 'Booking.where(\"created_at < ? AND NOT current\", 1.month.ago).delete_all'"
end