class RemoveTypeFromDays < ActiveRecord::Migration[5.2]
  def change
    remove_column :days, :type, :string
  end
end
