class RemoveWeeklyAvailabilityForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :events, :weekly_availabilities
  end
end
