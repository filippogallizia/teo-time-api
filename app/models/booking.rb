class Booking < ApplicationRecord
  belongs_to :user, :class_name => 'User', :foreign_key => "user_id"
  # TODO probably I can remove the trainer reference as we can get it from event
  belongs_to :trainer, :class_name => 'User', :foreign_key => "trainer_id"
  belongs_to :event
  belongs_to :weekly_availability
  validates_presence_of :start, :end, :trainer_id, :user_id, :event_id, :weekly_availability_id
  validate :validate_booking_fit_slot, on: [:create, :update]
  validate :validate_overlapping, on: [:create, :update]
  after_destroy :notification_on_delete
  after_commit :notification_on_create, on: [:create]

  include TimeHelper

  scope :future_bookings, -> { where("start > ?", Time.now) }

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
    #TODO add validation for recurrent bookings!!!

    if previous_changes.include?("start") || previous_changes.include?("end")
      all_bookings = Booking.where({ event_id: event.id, weekly_availability_id: weekly_availability_id, start: self.start.all_day })
      overlaps = all_bookings.find { |book| overlaps({ start: self.start, end: self.end }, { start: book.start, end: book.end }) }
      overlaps.present?
    else
      false
    end
  end

  def validate_booking_fit_slot
    event = Event.find(self.event_id)
    availability_on_the_fly = AvailabilityOnTheFly.new(
      {
        day_id: self.start.wday,
        weekly_availability_id: self.weekly_availability_id,
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

  def add_event_to_google_calendar
    begin
    calendar = GoogleCalendar.new
    event = calendar.event(self.event&.name, self.weekly_availability.address, "Event: #{self.event&.name}. Cliente: #{self.user.email}", self.start, self.end, self.start.to_datetime.zone)
    res = calendar.insert_event(event)
    self.update_column(:calendarEventId, res.id)
    rescue
      puts '
      ####################################
      # ERROR FROM GOOGLE ADD EVENT #
      ####################################'
    end
  end

  def change_date_to_start_end(date)
    self.start = date.to_datetime.change(hour: self.start.to_datetime.hour, minute: self.start.to_datetime.minute)
    self.end = date.to_datetime.change(hour: self.end.to_datetime.hour, minute: self.end.to_datetime.minute)
    self
  end

  def delete_event_from_google_calendar
    begin
      calendar = GoogleCalendar.new
      calendar.delete_event(self.calendarEventId)
    rescue
      puts '
      ####################################
      # ERROR FROM GOOGLE EVENT DELETION #
      ####################################'
    end
  end

  ``
  scope :inside_range, ->(range) {
    where.not(Arel.sql("start > '#{range[:end]}' OR end < '#{range[:start]}'"))
  }

  def custom_json
    {
      **self.attributes,
      user: self.user,
      trainer: self.trainer,
      event: self.event
    }
  end

  def send_confirmation_email
    begin
      BookingMailer.confirm([self.user.email, self.trainer.email], self).deliver_now
    rescue
      puts '
      #########################################
      # ERROR FROM SENG BOOKING CONFIRM EMAIL #
      #########################################'
    end
  end

  def send_delete_email
    begin
      BookingMailer.delete([self.user.email, self.trainer.email], self).deliver_now
    rescue
      puts 'error while sending email'
    end
  end

  def notification_on_create
    add_event_to_google_calendar
    send_confirmation_email
  end

  def notification_on_delete
    delete_event_from_google_calendar
    send_delete_email
  end

end
