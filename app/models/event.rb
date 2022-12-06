class Event < ApplicationRecord
  belongs_to :trainer, :class_name => 'User', :foreign_key => "trainer_id", optional: true
  has_many :bookings
  has_many :hours
  has_many :weekly_availability, through: :hours
  validates_presence_of :name, :trainer_id, :duration, :increment_amount

  def create_avail_slot
    id = read_attribute(self.id)
  end

  def hours_with_date_or_wday (date, day_id)
    hours_with_date = self.hours.where(date: date)
    hours_with_date.length > 0 ? hours_with_date : self.hours.where(day_id: day_id, date: nil)
  end
end
