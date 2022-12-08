class RemoveDateStartDateEndFromHour < ActiveRecord::Migration[5.2]
  def change
    remove_column :hours, :date_start, :date
    remove_column :hours, :date_end, :date
  end
end
