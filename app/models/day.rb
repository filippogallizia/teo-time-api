class Day < ApplicationRecord
  has_many :hours, dependent: :destroy
  has_many :weekly_availabilities, through: :hours
end
