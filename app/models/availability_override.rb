class AvailabilityOverride < ApplicationRecord
  belongs_to :weekly_availability
  has_many :hours, dependent: :destroy
  validates_presence_of :weekly_availability_id, :start_date, :end_date
end
