class AddDateStartToHours < ActiveRecord::Migration[5.2]
  def change
    add_column :hours, :date_start, :date
  end
end
