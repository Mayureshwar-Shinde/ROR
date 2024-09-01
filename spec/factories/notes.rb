FactoryBot.define do
  factory :note do
    content { "MyText" }
    case_id { nil }
    user_id { nil }
  end
end
