module TimeHelper
  def overlaps?(range_one, range_two)
    range_one[:start] <= range_two[:end] && range_two[:start] <= range_one[:end] || false
  end

  def create_slot (slots = [], incr = 0, event_duration = 60, range_availability)
    r = slots
    # binding.pry
    last_slot_element_end = r.length > 0 ? r.last[:end] : range_availability[:start].to_datetime
    incr_parsed = slots.length > 0 ? incr : 0
    return r if last_slot_element_end + incr_parsed.minutes + event_duration.minutes > range_availability[:end]
    r << { start: last_slot_element_end + incr_parsed.minutes, end: last_slot_element_end + incr_parsed.minutes + event_duration.minutes }
    create_slot(r, incr, event_duration, range_availability)
  end

  def divide_range_in_days(range)
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
end