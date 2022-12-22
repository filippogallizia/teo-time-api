module TimeHelper
  def overlaps?(range_one, range_two)
    (range_one[:start] <= range_two[:end] && range_two[:start] <= range_one[:end]) || false
  end

  def create_slot (slots = [], incr = 0, event_duration = 60, range_availability)
    r = slots
    last_slot_element_end = r.length > 0 ? r.last[:end] : range_availability[:start]
    incr_parsed = slots.length > 0 ? incr : 0
    if last_slot_element_end + incr_parsed.minutes + event_duration.minutes > range_availability[:end]
      return r
    end
    r << { start: last_slot_element_end + incr_parsed.minutes, end: last_slot_element_end + incr_parsed.minutes + event_duration.minutes }
    create_slot(r, incr, event_duration, range_availability)
  end

  def apply_time_to_another_date (date_one, date_two)
    date_one_datetime = date_one.to_datetime
    date_two_datetime = date_two.to_datetime
    date_one_datetime.change(hour: date_two_datetime.hour, minute: date_two_datetime.minute)
  end

  def divide_range_in_days(range_start, range_end)
    range_start.step(range_end).to_a
  end

  def range_one_fully_within_range_two? (range_one, range_two)
    range_one[:start] >= range_two[:start] && range_one[:end] <= range_two[:end]
  end

  def are_dates_equal?(date_one, date_two)
    date_one.strftime("%m/%d/%Y") == date_two.strftime("%m/%d/%Y")
  end

  def date_to_hour_and_minute_format (date)
    date.strftime('%H:%M')
  end

  def min_to_h (min)
    min / 60
  end

  def h_to_min(h)
    h * 60
  end

  def set_time_zone_to_date (date, time_zone)
    Time.find_zone(time_zone).local(date.year, date.month, date.day, date.hour, date.minute)
  end
end


