class AddEventToBookings < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :event, index: true
  end
end
