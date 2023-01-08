class Event < ApplicationRecord
  include TimeHelper
  belongs_to :trainer, :class_name => 'User', :foreign_key => "trainer_id", optional: true
  has_many :bookings
  has_many :hours
  has_many :weekly_availability, through: :hours
  validates_presence_of :name, :trainer_id, :duration, :increment_amount, :price

  def hours_with_date_or_wday (date, day_id, weekly_availability_id)
    hours_with_availabilities_override = self.hours.where.not(availability_override_id: nil).where(weekly_availability_id: weekly_availability_id)
    if hours_with_availabilities_override && hours_with_availabilities_override.size
      hours_with_availabilities_override_overlapping = hours_with_availabilities_override.select do |h|
        availability_override = AvailabilityOverride.find(h.availability_override_id)
        return unless availability_override
        range_one = { start: availability_override.start_date, end: availability_override.end_date }
        range_two = { start: date.at_beginning_of_day, end: date.end_of_day }
        overlaps?(range_one, range_two)
      end
    end
    hours_with_availabilities_override_overlapping&.length > 0 ? hours_with_availabilities_override_overlapping : self.hours.where(day_id: day_id, availability_override_id: nil, weekly_availability_id: weekly_availability_id)
  end

  def weekly_availabilities
    self.hours.map { |h| h.weekly_availability }.uniq
  end

  def custom_json(include = nil)
    {
      **self.attributes,
      trainer_email: User.find(self.trainer_id).email,
      weekly_availabilities: (include &&include[:weekly_availabilities]) && self.weekly_availabilities
    }
  end
end
