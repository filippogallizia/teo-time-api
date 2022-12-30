class User < ApplicationRecord
  has_many :trainers, :class_name => 'Booking', :foreign_key => 'trainer_id', dependent: :destroy
  has_many :trainers, :class_name => 'Event', :foreign_key => 'trainer_id', dependent: :destroy
  has_many :trainers, :class_name => 'Hour', :foreign_key => 'trainer_id', dependent: :destroy
  has_many :users, :class_name => 'Booking', :foreign_key => 'user_id', dependent: :destroy
  has_many :payments
  belongs_to :role

  before_create :set_default_role
  include AuthHelper

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def set_default_role
    self.role ||= Role.find_by_name('client')
  end

  def is_trainer
    self.role.trainer_role
  end

  def is_admin
    self.role.admin_role
  end

  def is_client
    self.role.client_role
  end
end
