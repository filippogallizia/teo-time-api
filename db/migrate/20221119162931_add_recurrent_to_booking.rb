class AddRecurrentToBooking < ActiveRecord::Migration[5.2]
  def change
    add_column :bookings, :recurrent, :boolean
  end
end
