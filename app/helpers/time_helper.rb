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

  def group_range_by_wday(range)
    start_range = range[:start].to_datetime
    end_range = range[:end].to_datetime
    range_divided_by_days = (start_range..end_range).each_with_object([]) do |day, array|
      start_date = day.day == start_range.day ? start_range : day.at_beginning_of_day
      end_date = day.day == end_range.day ? end_range : day.at_end_of_day
      array << { wday: day.wday,
                 date: day,
                 range: { start: start_date, end: end_date }
      }
    end
    range_divided_by_days.group_by { |hash| hash[:date].wday }
  end

  def create_avail_divided_by_date (rangeStart, rangeEnd, event)
    group_range_by_wday({ start: rangeStart, end: rangeEnd }).each { |day_id, array_wday|
      array_wday.each { |day_hash|
        # here we modify
        day_hash[:slots] = event.hours_with_date_or_wday(day_hash[:date], day_id).to_a.map { |hour|
          # day_hash[:slots] = event.hours.where({ day_id: key }).to_a.map { |hour|
          hour_start = hour.add_time_zone_to_hour(day_hash[:date])[:start]
          hour_end = hour.add_time_zone_to_hour(day_hash[:date])[:end]
          create_slot([], event.increment_amount, event.duration, { start: hour_start, end: hour_end })
        }.flatten
      }
    }
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

# WORKING VERSION
# def create_avail_divided_by_date (rangeStart, rangeEnd, event)
#   range_grouped_by_wday = group_range_by_wday({ start: rangeStart, end: rangeEnd })
#   range_grouped_by_wday.each { |key, value|
#     value.each { |hash|
#       # hash[:slots] = event.hours_with_date_or_wday(value[:date], key).to_a.map { |hour|
#       hash[:slots] = event.hours.where({ day_id: key }).to_a.map { |hour|
#         hour_start = hour.add_time_zone_to_hour(hash[:date])[:start]
#         hour_end = hour.add_time_zone_to_hour(hash[:date])[:end]
#         create_slot([], event.increment_amount, event.duration, { start: hour_start, end: hour_end })
#       }.flatten
#     }
#   }
# end

