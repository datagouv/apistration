FactoryBot.define do
  factory :editor_use_case do
    editor
    use_case { 'tarification_municipale_enfance' }
    software { 'Logiciel enfance' }
    scopes { %w[cnaf_quotient_familial] }
    security_accreditation { false }
  end
end
