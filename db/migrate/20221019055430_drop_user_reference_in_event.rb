class DropUserReferenceInEvent < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:events, :user, index: true)
  end
end
