FactoryBot.define do
  default_avatar_path = Rails.root.join('app/assets/images/default_avatar.png')

  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.birthday }
    age { Faker::Number.between(from: 18, to: 99) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { password }

    after(:create) do |user|
      user.avatar.attach(
        io: File.open(default_avatar_path),
        filename: 'default_avatar.png',
        content_type: 'image/png'
      )
    end
  end
end
