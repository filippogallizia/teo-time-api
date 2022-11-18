module AuthHelper
  # Example of env var value: "andy|tim|megan|mk|josh|warren|austin|tshelton|chris|milt|gprost|aurelien|keith|riley|neal"
  User::SUPER_USERS = /(#{ENV["SUPER_USERS"]} || 'filo')@gmail\.com/
end