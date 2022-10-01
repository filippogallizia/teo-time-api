class Event < ApplicationRecord
  belongs_to :weekly_availability, optional: true
  belongs_to :user, optional: true
  has_many :weekly_availabilities
  has_many :bookings
  validates_presence_of :name, :weekly_availability_id, :user_id, :duration, :increment_amount

  def create_avail_slot
    id = read_attribute(self.id)

  end
end
