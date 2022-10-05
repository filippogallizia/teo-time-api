class AddTrainerIdReferenceToBookings < ActiveRecord::Migration[5.2]
  def change
    add_reference :bookings, :trainer, foreign_key: { to_table: 'users' }
  end
end
