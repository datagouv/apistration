namespace '/api', constraints: APIParticulierDomainConstraint.new do
  get 'ping' => '/ping#show'
  get 'uptime' => '/uptime#show'
  get ':provider/ping' => '/api_particulier/ping_providers#show'

  get 'introspect' => '/api_particulier/introspect#show'

  get 'caf/famille' => '/api_particulier/v2/cnaf/quotient_familial#show'
  get 'impots/svair' => '/api_particulier/v2/dgfip/situation_ir#show'

  get 'open-api.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/openapi-particulier.yaml'))]] }
  get 'france-connect/open-api.yml', to: ->(env) do
    [200, {}, [File.read(Rails.root.join('swagger/api_particulier_open_api_static/france-connect-v2.yaml'))]]
  end

  namespace '/v2' do
    get 'complementaire-sante-solidaire' => '/api_particulier/v2/cnaf/complementaire_sante_solidaire#show'
    get 'composition-familiale-v2' => '/api_particulier/v2/cnaf/quotient_familial_v2#show'
    get 'composition-familiale' => '/api_particulier/v2/cnaf/quotient_familial#show'
    get 'situations-pole-emploi' => '/api_particulier/v2/pole_emploi/statut#show'
    get 'paiements-pole-emploi' => '/api_particulier/v2/pole_emploi/indemnites#show'
    get 'etudiants' => '/api_particulier/v2/mesri/student_status#show'
    get 'scolarites' => '/api_particulier/v2/men/scolarites#show'
    get 'etudiants-boursiers' => '/api_particulier/v2/cnous/student_scholarship#show'
    get 'avis-imposition' => '/api_particulier/v2/dgfip/situation_ir#show'
  end
end
