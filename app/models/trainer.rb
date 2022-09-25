class Trainer < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings

  has_many :events
  has_many :weekly_availabilities, through: :events

  devise :database_authenticatable, :timeoutable

  include AuthHelper
end
