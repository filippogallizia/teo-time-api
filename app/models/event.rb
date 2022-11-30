class Event < ApplicationRecord
  belongs_to :trainer, :class_name => 'User', :foreign_key => "trainer_id", optional: true
  has_many :bookings
  has_many :hours
  has_many :weekly_availability, through: :hours
  validates_presence_of :name, :weekly_availability_id, :trainer_id, :duration, :increment_amount
  after_commit :remove_event_from_hours

  def create_avail_slot
    id = read_attribute(self.id)
  end

  scope :filter_by_weekly_availability, ->(weekly_availability_id) { where(weekly_availability_id: weekly_availability_id) }

  def with_weekly_availability
    {
      **self.attributes,
      weekly_availability_name: self.weekly_availability.name
    }
  end

  def hours_with_date_or_wday (date, day_id)
    hours_with_date = self.hours.where(date: date)
    hours_with_date.length > 0 ? hours_with_date : self.hours.where(day_id: day_id, date: nil)
  end

  def remove_event_from_hours
    #TODO create test
    if self.previous_changes["weekly_availability_id"]
      self.hours&.where(weekly_availability_id: self.weekly_availability_id)&.update(event_id: nil)
    end
  end
end
