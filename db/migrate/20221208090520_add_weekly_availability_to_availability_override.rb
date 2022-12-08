class AddWeeklyAvailabilityToAvailabilityOverride < ActiveRecord::Migration[5.2]
  def change
    add_reference :availability_overrides, :weekly_availability, foreign_key: true
  end
end
