class AddRelationToHours < ActiveRecord::Migration[5.2]
  def change
    add_reference :hours, :weekly_availability
    add_reference :hours, :day
  end
end
