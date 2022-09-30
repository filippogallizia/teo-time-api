class AddWeeklyAvailabilityToBooking < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :weekly_availability, foreign_key: true
  end
end
