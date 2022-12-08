class WeeklyAvailability < ApplicationRecord
  has_many :hours, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :availability_overrides, dependent: :destroy
  has_many :days, through: :hours
  has_many :events, through: :hours
  include TimeHelper

end


