FactoryBot.define do
  factory :changelog_subscription do
    user
    scope { 'api_entreprise' }

    trait :api_particulier do
      scope { 'api_particulier' }
    end
  end
end
