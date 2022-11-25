class AddTypeToDays < ActiveRecord::Migration[5.2]
  def change
    add_column :days, :type, :string
  end
end
