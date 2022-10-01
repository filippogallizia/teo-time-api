class AddWeeklyAvailabilitiesToBookings < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :weekly_availability, index: true
  end
end
