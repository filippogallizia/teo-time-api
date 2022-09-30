class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :days, :start, :name
  end
end
