class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include AuthHelper
  has_many :bookings, dependent: :destroy

end
