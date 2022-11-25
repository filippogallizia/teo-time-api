class RemoveDateFromDays < ActiveRecord::Migration[5.2]
  def change
    remove_column :days, :date, :date
  end
end
