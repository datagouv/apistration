FactoryBot.define do
  factory :editor_delegation_campaign do
    editor
    api { 'entreprise' }
    datapass_form_uid { 'api-entreprise-marches-publics' }
    data do
      {
        'intitule' => 'Dématérialisation des marchés publics',
        'description' => 'Récupération des pièces justificatives des candidats',
        'contact_metier_email' => 'metier@editor.com',
        'contact_technique_email' => 'technique@editor.com'
      }
    end
  end
end
