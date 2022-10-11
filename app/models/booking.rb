class Booking < ApplicationRecord
  belongs_to :user, :class_name => 'User', :foreign_key => "user_id"
  belongs_to :trainer, :class_name => 'User', :foreign_key => "trainer_id"
  belongs_to :event
  belongs_to :weekly_availability
  validates_presence_of :start, :end, :trainer_id, :user_id, :event_id, :weekly_availability_id
  validate :validate_booking_fit_slot
  validate :validate_overlapping

  #todo validation for existing trainer_id, mysql dont work because double association on single table

  include TimeHelper

  def retrieve_week_day
    self.read_attribute(:start).wday
  end

  private

  def overlaps(range_one, range_two)
    # self.errors.add("This booking", "is overlaping an existing one") if range_one[:start] <= range_two[:end] && range_two[:start] <= range_one[:end]
    self.errors.add("This booking", "is overlaping an existing one") if overlaps?(range_one, range_two)
  end

  def validate_overlapping
    #TODO filter for event
    all_bookings = Booking.all
    all_bookings.each { |book| overlaps({ start: self.start, end: self.end }, { start: book.start, end: book.end }) } if all_bookings.length
  end

  def validate_booking_fit_slot
    day_id = self.start.to_datetime.wday
    event = Event.find(self.event_id)
    hours = Hour.where(weekly_availability: event.weekly_availability_id, day_id: day_id)
    slots = hours.each_with_object([]) { |h, array| array << create_slot([], event.increment_amount, event.duration, { start: self.start.to_datetime.at_beginning_of_day + h[:start].minutes, end: self.end.to_datetime.at_beginning_of_day + h[:end].minutes }) }.flatten
    match = slots.find { |slot| slot[:start] == self.start && slot[:end] == self.end }
    self.errors.add("Slot missing", "There is not a slot for this booking range") if !match
  end

  scope :inside_range, ->(range) {
    where.not(Arel.sql("start > '#{range[:end]}' OR end < '#{range[:start]}'"))
  }
end
