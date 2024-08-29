svair_gone = ->(env) do
  [410, {}, ["Cette URL n'existe plus sur API Particulier depuis le 8 janvier 2024. Veuillez mettre à jour votre application."]]
end

scope path: 'v:api_version', constraints: APIParticulierDomainConstraint.new(v3_and_more: true) do
  get 'mesri/statut_etudiant/ine', to: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_ine#show'
  get 'mesri/statut_etudiant/france_connect', to: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_france_connect#show'
  get 'mesri/statut_etudiant/civility', to: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_civility#show'

  get 'cnav/revenu_solidarite_active/france_connect', to: 'api_particulier/v3_and_more/cnav/revenu_solidarite_active_with_france_connect#show'
  get 'cnav/revenu_solidarite_active/civility', to: 'api_particulier/v3_and_more/cnav/revenu_solidarite_active_with_civility#show'

  get 'cnav/prime_activite/civility', to: 'api_particulier/v3_and_more/cnav/prime_activite_with_civility#show'
end

namespace '/api', constraints: APIParticulierV2DomainConstraint.new do
  get 'ping' => '/ping#show'

  get 'introspect' => '/api_particulier/v2/introspect#show'
  get 'france_connect_jwks' => '/api_particulier/france_connect_jwks#show'

  get 'caf/famille' => '/api_particulier/v2/cnaf/quotient_familial#show'
  get 'impots/svair', to: svair_gone

  get 'open-api.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/api_particulier_open_api_static/v2.yaml'))]] }
  get 'open-api-v3.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/openapi-particulier.yaml'))]] }
  get 'france-connect/open-api.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/api_particulier_open_api_static/v2.yaml'))]] }

  namespace '/v2' do
    get 'composition-familiale' => '/api_particulier/v2/cnaf/quotient_familial#show'

    get 'complementaire-sante-solidaire' => '/api_particulier/v2/cnav/complementaire_sante_solidaire#show'
    get 'composition-familiale-v2' => '/api_particulier/v2/cnav/quotient_familial_v2#show'
    get 'allocation-adulte-handicape' => '/api_particulier/v2/cnav/allocation_adulte_handicape#show'
    get 'allocation-soutien-familial' => '/api_particulier/v2/cnav/allocation_soutien_familial#show'
    get 'prime-activite' => '/api_particulier/v2/cnav/prime_activite#show'
    get 'revenu-solidarite-active' => '/api_particulier/v2/cnav/revenu_solidarite_active#show'

    get 'situations-pole-emploi' => '/api_particulier/v2/pole_emploi/statut#show'
    get 'paiements-pole-emploi' => '/api_particulier/v2/pole_emploi/indemnites#show'
    get 'etudiants' => '/api_particulier/v2/mesri/student_status#show'
    get 'scolarites' => '/api_particulier/v2/men/scolarites#show'
    get 'etudiants-boursiers' => '/api_particulier/v2/cnous/student_scholarship#show'
    get 'avis-imposition', to: svair_gone
  end
end

get 'api/:provider/ping', to: 'api_particulier/ping_providers#show', as: 'api_particulier_ping_provider', constraints: APIParticulierDomainConstraint.new
get 'api/pings', to: 'api_particulier/ping_providers#index', as: 'api_particulier_ping_providers', constraints: APIParticulierDomainConstraint.new
