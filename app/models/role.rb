class Role < ApplicationRecord
  has_many :users

  def client_role
    self.id == 1
  end

  def trainer_role
    self.id == 2
  end

  def admin_role
    self.id == 3
  end

end
