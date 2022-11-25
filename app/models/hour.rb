class Hour < ApplicationRecord
  belongs_to :weekly_availability, optional: true
  belongs_to :day, optional: true
  belongs_to :event, optional: true
  belongs_to :trainer, :class_name => 'User', :foreign_key => "trainer_id", optional: true
  validates_presence_of :weekly_availability_id, :day_id, :date, :start, :end, :time_zone
  # validate :hour_ranges_overlaps?

  include TimeHelper

  # TODO this fn always need to have a date
  def add_time_zone_to_hour(date)
    { start: add_minutes_to_specific_date(date, start, self.time_zone), end: add_minutes_to_specific_date(date, self.end, self.time_zone) }
  end

  def today_date_plus_minutes (minutes, time_zone)
    date_parsed = set_time_zone_to_date(DateTime.now.midnight, time_zone)
    date_parsed + minutes.minutes
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
    date_parsed.midnight + minutes.minutes
  end
end
