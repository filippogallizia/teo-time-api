ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

def week_days_with_datetime(day, minutes = 0)
  days_of_week = {
    monday: '2022-11-14T00:00:00.000Z',
    tuesday: '2022-11-15T00:00:00.000Z',
    wednesday: '2022-11-16T00:00:00.000Z',
    thursday: '2022-11-17T00:00:00.000Z',
    friday: '2022-11-18T00:00:00.000Z',
    saturday: '2022-11-19T00:00:00.000Z',
    sunday: '2022-11-20T00:00:00.000Z'
  }

  (days_of_week[day].to_datetime + minutes.minutes).to_s
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Add more helper methods to be used by all tests here...
end
