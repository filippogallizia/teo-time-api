class Booking < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :trainer, optional: true
end
