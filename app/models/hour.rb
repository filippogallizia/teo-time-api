class Hour < ApplicationRecord
  belongs_to :weekly_availability, optional: true
  belongs_to :day, optional: true

end
