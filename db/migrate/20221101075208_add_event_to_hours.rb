class AddEventToHours < ActiveRecord::Migration[5.2]
  def change
    add_reference :hours, :event, index: true
  end
end
