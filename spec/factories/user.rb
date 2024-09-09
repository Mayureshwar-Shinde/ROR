FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(from: '2000-01-01', to: '2024-07-31') }
    age { Faker::Number.between(from: 18, to: 99) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { password }
    phone { Faker::PhoneNumber.phone_number }

    after(:create) do |user|
      user.avatar.attach(
        io: File.open(default_avatar_path),
        filename: 'default_avatar.png',
        content_type: 'image/png'
      )
    end
  end
end
