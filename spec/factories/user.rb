FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday }
    age { Faker::Number.between(from: 18, to: 99) }
    email { "#{first_name}#{last_name}@gmail.com" }
    password { 'password' }
    password_confirmation { password }
  end
end
