FactoryBot.define do
  factory :editor_delegation_request do
    editor_use_case
    siret { generate(:siret) }
    contact_email { generate(:email) }

    trait :with_authorization_request do
      authorization_request { association :authorization_request, :without_external_id, siret:, demarche: editor_use_case.datapass_form_uid }
    end

    trait :with_dpo do
      data do
        {
          'delegue_protection_donnees_given_name' => 'Dominique',
          'delegue_protection_donnees_family_name' => 'Leroy',
          'delegue_protection_donnees_email' => 'dpo@saint-exemple.fr',
          'delegue_protection_donnees_phone_number' => '0123456789',
          'delegue_protection_donnees_job_title' => 'DPO'
        }
      end
    end

    trait :submitted do
      with_dpo

      submitted_at { Time.zone.now }
      submitted_by_user factory: :user
    end
  end
end
