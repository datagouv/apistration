FactoryBot.define do
  factory :admin_activity do
    name { 'impersonation_started' }
    namespace { 'entreprise' }
    admin factory: %i[user admin]
    entity factory: %i[user]

    trait :token_banned do
      name { 'token_banned' }
      entity factory: %i[token]
      before_attributes { { 'blacklisted_at' => nil } }
      after_attributes { { 'blacklisted_at' => 1.month.from_now } }
    end
  end
end
