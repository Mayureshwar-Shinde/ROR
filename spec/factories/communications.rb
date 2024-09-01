FactoryBot.define do
  factory :communication do
    from { nil }
    to { nil }
    subject { "MyString" }
    message { "MyString" }
    case_id { nil }
  end
end
