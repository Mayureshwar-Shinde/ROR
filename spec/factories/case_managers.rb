FactoryBot.define do
  default_avatar_path = Rails.root.join('app/assets/images/case_manager_avatar.png')

  factory :case_manager do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.between(from: '2000-01-01', to: '2024-07-31') }
    age { Faker::Number.between(from: 18, to: 99) }
    email { "#{first_name}#{last_name}@gmail.com"}
    password { 'password' }
    password_confirmation { password }

    after(:create) do |case_manager|
      case_manager.avatar.attach(
        io: File.open(default_avatar_path),
        filename: 'case_manager_avatar.png',
        content_type: 'image/png'
      )
    end
  end
end
