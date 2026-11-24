FactoryBot.define do
  factory :editor_use_case do
    editor
    use_case { 'tarification_municipale_enfance' }
    software { 'Logiciel enfance' }
    scopes { %w[cnaf_quotient_familial] }
    integration_status { 'production' }

    before(:create) do |editor_use_case|
      create(:datapass_form, use_case: editor_use_case.use_case) unless DatapassForm.exists?(use_case: editor_use_case.use_case)
    end
  end
end
