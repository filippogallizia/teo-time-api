class User < ApplicationRecord
  has_many :bookings, dependent: :destroy
  has_many :trainers, through: :bookings
  belongs_to :role
  before_create :set_default_role
  include AuthHelper

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def set_default_role
    self.role ||= Role.find_by_name('client')
  end
end
