FactoryBot.define do
  factory :appointment do
    date { "2024-08-22" }
    start_time { "2024-08-22 15:25:47" }
    end_time { "2024-08-22 15:25:47" }
    status { "MyString" }
    case_id { nil }
    scheduler_id { nil }
    schedulee_id { nil }
  end
end
