class Booking < ApplicationRecord
  belongs_to :user, :class_name => 'User'
  belongs_to :trainer, :class_name => 'User'
  belongs_to :event
  belongs_to :weekly_availability
  validates_presence_of :start, :end, :trainer_id, :user_id, :event_id, :weekly_availability_id
  validate :validate_overlapping

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
    all_bookings = Booking.all
    all_bookings.each { |book| overlaps({ start: self.start, end: self.end }, { start: book.start, end: book.end }) } if all_bookings.length
  end

  scope :inside_range, ->(range) {
    where.not(Arel.sql("start > '#{range[:end]}' OR end < '#{range[:start]}'"))
  }
end
