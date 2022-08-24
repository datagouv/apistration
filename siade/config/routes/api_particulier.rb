namespace '/api/v2', constraints: APIParticulierDomainConstraint.new do
  get 'composition-familiale' => '/api_particulier/v2/cnaf/quotient_familial#show'
  get 'situations-pole-emploi' => '/api_particulier/v2/pole_emploi/statut#show'
  get 'etudiants' => '/api_particulier/v2/mesri/student_status#show'
  get 'etudiants-boursiers' => '/api_particulier/v2/cnous/student_scholarship#show'
  get 'avis-imposition' => '/api_particulier/v2/dgfip/svair#show'
end
