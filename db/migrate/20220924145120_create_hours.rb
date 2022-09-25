class CreateHours < ActiveRecord::Migration[5.2]
  def change
    create_table :hours do |t|
      t.string :start
      t.string :time
      t.string :end
      t.string :time

      t.timestamps
    end
  end
end
