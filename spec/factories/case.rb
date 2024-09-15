FactoryBot.define do
  factory :case do
    case_number { "##{SecureRandom.hex(3).upcase}" }
    title { 'Title' }
    description { 'This is the random generated text' }
    status { 'open' }
    user { association :case_manager }
    assigned_to { association :dispute_analyst }
  end
end
