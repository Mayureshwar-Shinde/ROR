FactoryBot.define do
  factory :case do
    case_number { "CASE-#{SecureRandom.hex(4).upcase}" }
    title { "Title" }
    description { "This is the random generated text" }
    status { 'open' }
    user { nil }
    assigned_to { nil }
  end
end
