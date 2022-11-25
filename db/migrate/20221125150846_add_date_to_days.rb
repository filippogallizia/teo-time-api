class AddDateToDays < ActiveRecord::Migration[5.2]
  def change
    add_column :days, :date, :date
  end
end
