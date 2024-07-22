svair_gone = ->(env) do
  [410, {}, ["Cette URL n'existe plus sur API Particulier depuis le 8 janvier 2024. Veuillez mettre à jour votre application."]]
end

namespace '/api', constraints: APIParticulierDomainConstraint.new do
  get 'ping' => '/ping#show'

  get 'introspect' => '/api_particulier/v2/introspect#show'

  get 'caf/famille' => '/api_particulier/v2/cnaf/quotient_familial#show'
  get 'impots/svair', to: svair_gone

  get 'open-api.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/openapi-particulier.yaml'))]] }
  get 'france-connect/open-api.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/openapi-particulier.yaml'))]] }

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
