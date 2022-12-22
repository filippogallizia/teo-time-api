class Booking < ApplicationRecord
  belongs_to :user, :class_name => 'User', :foreign_key => "user_id"
  # TODO probably I can remove the trainer reference as we can get it from event
  belongs_to :trainer, :class_name => 'User', :foreign_key => "trainer_id"
  belongs_to :event
  belongs_to :weekly_availability
  validates_presence_of :start, :end, :trainer_id, :user_id, :event_id, :weekly_availability_id
  validate :validate_booking_fit_slot, on: [:create, :update]
  validate :validate_overlapping, on: [:create, :update]
  before_create :add_to_calendar
  after_destroy :delete_from_calendar

  include TimeHelper

  def retrieve_week_day
    self.read_attribute(:start).wday
  end

  def give_date_to_recurrent_bookings(range, recurrent_bookings)
    recurrent_bookings.start = apply_time_to_another_date(range[:date], recurrent_bookings[:start])
    recurrent_bookings.end = apply_time_to_another_date(range[:date], recurrent_bookings[:end])
    recurrent_bookings
  end

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
    event = Event.find(self.event_id)
    availability_on_the_fly = AvailabilityOnTheFly.new(
      {
        day_id: self.start.wday,
        date: self.start.to_datetime,
        range: { start: self.start.to_datetime.at_beginning_of_day, end: self.end.to_datetime.at_end_of_day },
        event: event,
        bookings: [],
        recurrent_bookings: [],
        slots: []
      }
    )
    availability_on_the_fly.set_slots
    match = availability_on_the_fly.slots.find { |slot| slot[:start] == self.start && slot[:end] == self.end }
    self.errors.add("Slot missing", "There is not a slot for this booking range") if !match
  end

  def add_to_calendar
    calendar = GoogleCalendar.new
    event = calendar.event('trainining', 'Milan', 'osteo train', self.start, self.end, self.start.to_datetime.zone)
    res = calendar.insert_event(event)
    self.calendarEventId = res.id
  end

  def change_date_to_start_end(date)
    self.start = date.to_datetime.change(hour: self.start.to_datetime.hour, minute: self.start.to_datetime.minute)
    self.end = date.to_datetime.change(hour: self.end.to_datetime.hour, minute: self.end.to_datetime.minute)
    self
  end

  def delete_from_calendar
    begin
      calendar = GoogleCalendar.new
      calendar.delete_event(self.calendarEventId)
    rescue
      puts 'calendar event was not found'
    end
  end

  ``
  scope :inside_range, ->(range) {
    where.not(Arel.sql("start > '#{range[:end]}' OR end < '#{range[:start]}'"))
  }

end
