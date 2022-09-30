class ChangeColumnType < ActiveRecord::Migration[5.2]
  def change
    change_column :hours, :start, :time
    change_column :hours, :end, :time
  end
end
