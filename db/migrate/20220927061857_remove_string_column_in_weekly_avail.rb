class RemoveStringColumnInWeeklyAvail < ActiveRecord::Migration[5.2]
  def change
    remove_column :weekly_availabilities, :string
  end
end
