class Event < ApplicationRecord
  belongs_to :trainer, optional: true
  belongs_to :weekly_availability, optional: true
end
