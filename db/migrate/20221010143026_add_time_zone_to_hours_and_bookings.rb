class AddTimeZoneToHoursAndBookings < ActiveRecord::Migration[5.2]
  def change
    add_column :hours, :time_zone, :string
    add_column :bookings, :time_zone, :string
  end
end
