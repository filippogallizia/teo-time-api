class AddLocationToWeeklyAvailability < ActiveRecord::Migration[5.2]
  def change
    add_column :weekly_availabilities, :address, :string
  end
end
