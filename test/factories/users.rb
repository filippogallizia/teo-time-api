FactoryBot.define do
  factory :user do
    email { "galliziafilippo@gmail.com" }
    password { 'filoculo' }
    password_confirmation { 'filoculo' }
    role_id { 1 }
  end
end