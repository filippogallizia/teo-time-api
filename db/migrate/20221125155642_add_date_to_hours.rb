class AddDateToHours < ActiveRecord::Migration[5.2]
  def change
    add_column :hours, :date, :date
  end
end
