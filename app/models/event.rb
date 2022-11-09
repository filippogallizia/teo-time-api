class Event < ApplicationRecord
  belongs_to :weekly_availability, optional: true
  belongs_to :trainer, :class_name => 'User', :foreign_key => "trainer_id", optional: true
  has_many :weekly_availabilities
  has_many :bookings
  has_many :hours
  validates_presence_of :name, :weekly_availability_id, :trainer_id, :duration, :increment_amount

  def create_avail_slot
    id = read_attribute(self.id)
  end

  def with_weekly_availability
    {
      **self.attributes,
      weekly_availability_name: self.weekly_availability.name
    }
  end
end
