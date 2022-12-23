class AvailabilityOnTheFly
  include TimeHelper
  attr_accessor :day_id, :range, :bookings, :date, :slots, :bookings, :recurrent_bookings, :event, :weekly_availability_id

  def initialize(args)
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def set_bookings_insider_range
    return unless event
    # TODO IMPROVE THIS QUERY
    self.bookings = event.bookings.where.not({ recurrent: true }).or(event.bookings.where(recurrent: nil)).inside_range({ start: range[:start], end: range[:end] })
  end

  def set_recurrent_bookings
    return unless event
    self.recurrent_bookings = event.bookings.where({ recurrent: true }).map { |book| book.change_date_to_start_end(self.date) }
  end

  def set_slots
    return unless event.present? && date
    self.slots = event.hours_with_date_or_wday(date, date.wday, weekly_availability_id).to_a.map { |hour|
      hour_start = hour.add_time_zone_to_hour(date)[:start]
      hour_end = hour.add_time_zone_to_hour(date)[:end]
      create_slot([], event.increment_amount, event.duration, { start: hour_start, end: hour_end })
    }.flatten
  end

  def compare_slots_with_bookings
    set_bookings_insider_range
    set_recurrent_bookings
    all_bookings = [*bookings, *recurrent_bookings]
    slots if all_bookings.size == 0
    all_bookings.each do |bkg|
      if are_dates_equal?(date, bkg[:start])
        self.slots = slots.select { |slot| overlaps?({ start: bkg[:start], end: bkg[:end] }, { start: slot[:start], end: slot[:end] }) == false }
      end
    end
  end

end

