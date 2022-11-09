class AddReferenceTrainerToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :trainer, foreign_key: { to_table: 'users' }
  end
end
