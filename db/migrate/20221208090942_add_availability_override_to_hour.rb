class AddAvailabilityOverrideToHour < ActiveRecord::Migration[5.2]
  def change
    add_reference :hours, :availability_override, foreign_key: true
  end
end
