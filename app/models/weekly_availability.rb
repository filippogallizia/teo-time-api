class WeeklyAvailability < ApplicationRecord
  has_many :hours, dependent: :destroy
  has_many :days, through: :hours

  has_many :events, dependent: :destroy
  has_many :trainers, through: :events
end
