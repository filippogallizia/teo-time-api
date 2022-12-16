class AvailabilityOnTheFly
  include TimeHelper
  attr_accessor :day_id, :range, :bookings, :date, :slots, :bookings, :recurrent_bookings, :event

  def initialize(args)
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def wday
    self.date.wday
  end

  def get_bookings_insider_range
    return unless self.event
    self.event.bookings.where({ recurrent: nil }).inside_range({ start: self.range[:start], end: self.range[:end] })
  end

  def get_recurrent_bookings
    return unless self.event
    self.event.bookings.where({ recurrent: true })
  end

  def compare_slots_with_bookings
    bookings = [*self.get_bookings_insider_range, *self.get_recurrent_bookings]
    self.slots if bookings.size == 0
    bookings.each do |bkg|
      if are_dates_equal?(self.date, bkg[:start])
        self.slots = self.slots.select { |slot| overlaps?({ start: bkg[:start], end: bkg[:end] }, { start: slot[:start], end: slot[:end] }) == false }
      end
    end
  end

end

