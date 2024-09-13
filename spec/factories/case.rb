FactoryBot.define do
  factory :case do
    association :user
    case_number { "##{SecureRandom.hex(3).upcase}" }
    title { 'Title' }
    description { 'This is the random generated text' }
    status { 'open' }
    assigned_to { nil }
  end
end
