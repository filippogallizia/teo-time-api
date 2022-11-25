class RemoveStringFromDays < ActiveRecord::Migration[5.2]
  def change
    remove_column :days, :string, :string
  end
end
