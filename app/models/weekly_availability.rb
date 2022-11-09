class WeeklyAvailability < ApplicationRecord
  has_many :hours, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :days, through: :hours
  has_many :events
  include TimeHelper

end


