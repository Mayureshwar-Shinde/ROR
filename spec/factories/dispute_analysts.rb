FactoryBot.define do
  default_avatar_path = Rails.root.join('app/assets/images/dispute_analyst_avatar.png')

  factory :dispute_analyst do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(from: '2000-01-01', to: '2024-07-31') }
    age { Faker::Number.between(from: 18, to: 99) }
    email { "#{first_name}#{last_name}@gmail.com" }
    password { 'password' }
    password_confirmation { password }
    role_type { 2 }

    after(:create) do |dispute_analyst|
      dispute_analyst.avatar.attach(
        io: File.open(default_avatar_path),
        filename: 'dispute_analyst_avatar.png',
        content_type: 'image/png'
      )
    end
  end
end
