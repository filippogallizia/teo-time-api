class ChangeCalendarIdType < ActiveRecord::Migration[5.2]
  def change
    change_column(:bookings, :calendarEventId, :string)
  end
end
