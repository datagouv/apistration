FactoryBot.define do
  factory :datapass_form do
    sequence(:uid) { |n| "api-particulier-form-#{n}" }
    api { 'particulier' }
    use_case { 'tarification_municipale_enfance' }
    name { 'Formulaire DataPass' }
    scopes { %w[cnaf_quotient_familial] }
    data { { 'scopes' => scopes } }
    synced_at { Time.current }
  end

  factory :datapass_scope do
    api { 'particulier' }
    sequence(:value) { |n| "scope_#{n}" }
    name { value.humanize }
    group { 'Groupe' }
    synced_at { Time.current }
  end
end
