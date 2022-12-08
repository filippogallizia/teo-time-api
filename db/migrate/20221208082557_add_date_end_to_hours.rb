class AddDateEndToHours < ActiveRecord::Migration[5.2]
  def change
    add_column :hours, :date_end, :date
  end
end
