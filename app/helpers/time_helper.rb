module TimeHelper
  def overlaps?(range_one, range_two)
    false ? range_one[:start] <= range_two[:end] && range_two[:start] <= range_one[:end] : true
  end

  def create_slot (slots = [], increment, event_duration, range_availability)
    r = slots
    # binding.pry
    last_slot_element_end = r.length > 0 ? r.last[:end] : range_availability[:start].to_datetime
    increment_parsed = slots.length > 0 ? increment : 0
    return r if last_slot_element_end + increment_parsed.minutes + event_duration.minutes > range_availability[:end]
    r << { start: last_slot_element_end + increment_parsed.minutes, end: last_slot_element_end + increment_parsed.minutes + event_duration.minutes }
    create_slot(r, increment, event_duration, range_availability)
  end

end