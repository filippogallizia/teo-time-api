class AddUserToPayments < ActiveRecord::Migration[5.2]
  def change
    add_reference :payments, :user, index: true
  end
end
