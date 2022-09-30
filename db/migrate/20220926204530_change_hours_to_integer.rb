class ChangeHoursToInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :hours, :start, :integer
    change_column :hours, :end, :integer
  end
end
