class AddReferenceToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :weekly_availability, foreign_key: true
  end
end
