FactoryBot.define do
  factory :event do
    name { "filo_event" }
    increment_amount { 30 }
    duration { 60 }
  end
end