class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.string :transaction_id
      t.string :status
      t.timestamps
    end
  end
end
