FactoryBot.define do
  factory :editor do
    name { 'UMAD Editor' }
    apis { %w[entreprise particulier] }
    transient do
      form_uids { [] }
    end

    after(:create) do |editor, evaluator|
      evaluator.form_uids.each { |form_uid| create(:editor_use_case, editor:, form_uid:) }
    end

    trait :delegable do
      editor_tokens_enabled { true }
    end

    trait :full do
      siret { '12345678901234' }
      role { 'manages_token' }
      deployment_type { 'saas' }
      domain { 'editor.com' }
      languages { 'Ruby, Python' }
      description { 'Un éditeur de test' }
      allowed_ips { ['1.2.3.4', '5.6.7.8'] }
      setup_instructions { 'Configurer le jeton via le dashboard' }

      after(:create) do |editor|
        create(:editor_contact, editor:)
      end
    end
  end
end
