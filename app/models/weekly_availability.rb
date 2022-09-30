class WeeklyAvailability < ApplicationRecord
  has_many :hours, dependent: :destroy
  has_many :days, through: :hours
  has_many :events
  include TimeHelper

  def group_hours_by_day
    arr_of_hash = hours.group_by { |h| h.day_id }.map do |key, value|
      res = {}
      res[key] = value.map { |hour| hour.get_start_end }
      res
    end

    hash = arr_of_hash.each_with_object({}) do |item, hash|
      hash[item.keys[0]] = item.values[0]
    end

    r = hash.transform_values { |values|
      values.map { |v| create_slot(30, 60, { start: v[:start], end: v[:end] }) }
    }
    r
  end

end
