class WeeklyAvailability < ApplicationRecord
  has_many :hours, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :days, through: :hours
  has_many :events
  include TimeHelper

  def group_hours_by_day
    hours.group_by { |h| h.day_id }.each_with_object({}) do |(key, value), hash|
      hash[key] = value.map { |hour| hour.get_start_end }
    end
  end
end


