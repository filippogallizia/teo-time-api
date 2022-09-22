module AuthHelper

  def is_super_user
    email == 'superUser@gmail.com'
  end

  def is_trainer
    email == 'trainer@gmail.com' if email
  end

  def is_admin
    read_attribute(:role) == 'admin'
  end

  def is_client
    true if !is_trainer && !is_super_user && !is_admin
  end

  # Example of env var value: "andy|tim|megan|mk|josh|warren|austin|tshelton|chris|milt|gprost|aurelien|keith|riley|neal"
  User::SUPER_USERS = /(#{ENV["SUPER_USERS"]} || 'filo')@gmail\.com/
end