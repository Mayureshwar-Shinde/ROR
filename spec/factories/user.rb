FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(from: '2000-01-01', to: '2024-07-31') }
    age { Faker::Number.between(from: 18, to: 99) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }
    phone { Faker::PhoneNumber.phone_number }
  end
end
