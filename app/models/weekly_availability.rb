class WeeklyAvailability < ApplicationRecord
  has_many :hours, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :days, through: :hours
  has_many :events
  include TimeHelper

  def group_hours_by_day
    hours.group_by { |h| h.day_id }.map do |key, value|
      res = {}
      res[key] = value.map { |hour| hour.get_start_end }
      res
    end.each_with_object({}) do |item, hash|
      hash[item.keys[0]] = item.values[0]
    end
  end
end


