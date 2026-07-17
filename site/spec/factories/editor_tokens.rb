FactoryBot.define do
  factory :editor_token do
    editor

    trait :expired do
      exp { 1.month.ago.to_i }
    end

    trait :blacklisted do
      blacklisted_at { 1.month.ago }
    end
  end
end
