class Trainer < ApplicationRecord
  devise :database_authenticatable, :timeoutable
  
  include AuthHelper
  has_many :bookings, dependent: :destroy
end
