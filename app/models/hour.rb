class Hour < ApplicationRecord
  belongs_to :weekly_availability, optional: true
  belongs_to :day, optional: true
  validates_presence_of :weekly_availability_id, :day_id, :start, :end

  def get_start_end
    # need to use self because end is reserved word
    { start: today_date_plus_minutes(start), end: today_date_plus_minutes(self.end) }
  end

  def today_date_plus_minutes (minutes)
    DateTime.now.midnight + minutes.minutes
  end
end
