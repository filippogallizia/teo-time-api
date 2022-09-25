class Booking < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :trainer, optional: true

  validates_associated :trainer
  validates_associated :user
  validates_presence_of :start, :end, :trainer_id, :user_id
  validate :validate_overlapping

  private

  def overlaps(range_one, range_two)
    self.errors.add("This booking", "is overlaping an existing one") if range_one[:start] <= range_two[:end] && range_two[:start] <= range_one[:end]
  end

  def validate_overlapping
    all_bookings = Booking.all
    all_bookings.each { |book| overlaps({ start: self.start, end: self.end }, { start: book.start, end: book.end }) }
  end

  # Return a scope for all interval overlapping the given interval, excluding the given interval itself
  # scope :overlapping, -> { |interval|
  #   where("id <> ? AND start_date <= ? AND ? <= end_date", interval.id, interval.end_date, interval.start_date)
  # }

end
