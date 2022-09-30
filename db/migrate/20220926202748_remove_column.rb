class RemoveColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :days, :start
    remove_column :hours, :time
  end
end
