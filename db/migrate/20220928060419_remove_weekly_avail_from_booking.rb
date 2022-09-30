class RemoveWeeklyAvailFromBooking < ActiveRecord::Migration[5.2]
  def change
    remove_reference :bookings, :weekly_availability, foreign_key: true
  end
end
