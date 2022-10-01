class AddDurationIncrementToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :duration, :integer
    add_column :events, :increment_amount, :integer
  end
end
