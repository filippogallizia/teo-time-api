class Hour < ApplicationRecord
  belongs_to :weekly_availability, optional: true
  belongs_to :day, optional: true
  validates_presence_of :weekly_availability_id, :day_id, :start, :end, :time_zone
  validate :hour_ranges_overlaps?

  include TimeHelper

  def get_start_end(date, time_zone = 'UTC')
    if date
      { start: add_minutes_to_specific_date(date, start, time_zone), end: add_minutes_to_specific_date(date, self.end, time_zone) }
    else
      { start: today_date_plus_minutes(start), end: today_date_plus_minutes(self.end) }
    end
  end

  def today_date_plus_minutes (minutes)
    DateTime.now.midnight + minutes.minutes
  end

  def hour_ranges_overlaps?
    hour = Hour.find_by({ weekly_availability_id: self.weekly_availability_id, day_id: self.day_id })
    return false unless hour
    self.errors.add("This hour", "is overlaping an existing one") if overlaps?({ start: hour[:start], end: hour[:end] }, { start: self.start, end: self.end })
  end

  def start_end_in_hours
    { **self.as_json, start: min_to_h(self.start), end: min_to_h(self.end) }
  end

  def add_minutes_to_specific_date(date, minutes, time_zone)
    date_parsed = set_time_zone_to_date(date.midnight, time_zone)
    # binding.pry
    date_parsed.midnight + minutes.minutes
  end
end
