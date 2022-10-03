class Hour < ApplicationRecord
  belongs_to :weekly_availability, optional: true
  belongs_to :day, optional: true
  validates_presence_of :weekly_availability_id, :day_id, :start, :end

  def get_start_end
    { start: today_date_plus_minutes(start), end: today_date_plus_minutes(self.end) }
  end

  def get_start_end2(date)
    { start: add_minutes_to_specific_date(date, start), end: add_minutes_to_specific_date(date, self.end) }
  end

  def today_date_plus_minutes (minutes)
    DateTime.now.midnight + minutes.minutes
  end

  def add_minutes_to_specific_date (date, minutes)
    date.midnight + minutes.minutes
  end
end
