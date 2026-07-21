FactoryBot.define do
  factory :editor do
    name { 'UMAD Editor' }
    apis { %w[entreprise particulier] }
    form_uids do
      [
        'umad-editor'
      ]
    end

    trait :delegable do
      delegations_enabled { true }
    end

    trait :full do
      siret { '12345678901234' }
      role { 'manages_token' }
      contact_email { 'contact@editor.com' }
      contact_phone { '0123456789' }
      deployment_type { 'saas' }
      domain { 'editor.com' }
      languages { 'Ruby, Python' }
      description { 'Un éditeur de test' }
      allowed_ips { ['1.2.3.4', '5.6.7.8'] }
      setup_instructions { 'Configurer le jeton via le dashboard' }
    end
  end
end
