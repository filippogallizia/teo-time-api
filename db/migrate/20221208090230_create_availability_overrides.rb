class CreateAvailabilityOverrides < ActiveRecord::Migration[5.2]
  def change
    create_table :availability_overrides do |t|
      t.date :start_date
      t.date :end_date
      t.timestamps
    end
  end
end
