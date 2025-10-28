svair_gone = lambda do |env|
  [410, {}, ["Cette URL n'existe plus sur API Particulier depuis le 8 janvier 2024. Veuillez mettre à jour votre application."]]
end

qf_v1_gone = lambda do |env|
  [410, {}, ["L'API Quotient Familial v1 n'est plus disponible depuis le 31/10/2025. Veuillez utiliser l'API v2 : https://particulier.api.gouv.fr/catalogue/cnav/quotient_familial"]]
end

scope path: 'v:api_version', constraints: APIParticulierDomainConstraint.new(v3_and_more: true) do
  get 'ants/extrait_immatriculation_vehicule/france_connect', to: 'api_particulier/v3_and_more/ants/extrait_immatriculation_vehicule_with_france_connect#show'

  get 'mesri/statut_etudiant/ine', to: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_ine#show'
  get 'mesri/statut_etudiant/france_connect', to: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_france_connect#show'
  get 'mesri/statut_etudiant/identite', to: 'api_particulier/v3_and_more/mesri/statut_etudiant_with_civility#show'

  get 'men/scolarites/identite', to: 'api_particulier/v3_and_more/men/scolarites_with_civility#show'

  get 'cnous/etudiant_boursier/ine', to: 'api_particulier/v3_and_more/cnous/etudiant_boursier_with_ine#show'
  get 'cnous/etudiant_boursier/identite', to: 'api_particulier/v3_and_more/cnous/etudiant_boursier_with_civility#show'
  get 'cnous/etudiant_boursier/france_connect', to: 'api_particulier/v3_and_more/cnous/etudiant_boursier_with_france_connect#show'

  get 'dsnj/service_national/identite', to: 'api_particulier/v3_and_more/dsnj/service_national_with_civility#show'
  get 'dsnj/service_national/france_connect', to: 'api_particulier/v3_and_more/dsnj/service_national_with_france_connect#show'

  get 'dss/revenu_solidarite_active/france_connect', to: 'api_particulier/v3_and_more/cnav/revenu_solidarite_active_with_france_connect#show'
  get 'dss/revenu_solidarite_active/identite', to: 'api_particulier/v3_and_more/cnav/revenu_solidarite_active_with_civility#show'

  get 'dss/prime_activite/identite', to: 'api_particulier/v3_and_more/cnav/prime_activite_with_civility#show'
  get 'dss/prime_activite/france_connect', to: 'api_particulier/v3_and_more/cnav/prime_activite_with_france_connect#show'

  get 'dss/allocation_soutien_familial/identite', to: 'api_particulier/v3_and_more/cnav/allocation_soutien_familial_with_civility#show'
  get 'dss/allocation_soutien_familial/france_connect', to: 'api_particulier/v3_and_more/cnav/allocation_soutien_familial_with_france_connect#show'

  get 'dss/allocation_adulte_handicape/identite', to: 'api_particulier/v3_and_more/cnav/allocation_adulte_handicape_with_civility#show'
  get 'dss/allocation_adulte_handicape/france_connect', to: 'api_particulier/v3_and_more/cnav/allocation_adulte_handicape_with_france_connect#show'

  get 'dss/complementaire_sante_solidaire/identite', to: 'api_particulier/v3_and_more/cnav/complementaire_sante_solidaire_with_civility#show'
  get 'dss/complementaire_sante_solidaire/france_connect', to: 'api_particulier/v3_and_more/cnav/complementaire_sante_solidaire_with_france_connect#show'

  get 'dss/quotient_familial/identite', to: 'api_particulier/v3_and_more/cnav/quotient_familial_with_civility#show'
  get 'dss/quotient_familial/france_connect', to: 'api_particulier/v3_and_more/cnav/quotient_familial_with_france_connect#show'

  get 'dss/participation_familiale_eaje/identite', to: 'api_particulier/v3_and_more/cnav/participation_familiale_eaje_with_civility#show'
  get 'dss/participation_familiale_eaje/france_connect', to: 'api_particulier/v3_and_more/cnav/participation_familiale_eaje_with_france_connect#show'

  get 'france_travail/statut/identifiant', to: 'api_particulier/v3_and_more/france_travail/statut_with_identifiant#show'

  get 'france_travail/indemnites/identifiant', to: 'api_particulier/v3_and_more/france_travail/indemnites_with_identifiant#show'

  get 'sdh/statut_sportif/identifiant', to: 'api_particulier/v3_and_more/sdh/statut_sportif_with_identifiant#show'
end

namespace '/api', constraints: APIParticulierV2DomainConstraint.new do
  get 'ping' => '/ping#show'

  get 'introspect' => '/api_particulier/v2/introspect#show'
  get 'france_connect_jwks' => '/api_particulier/france_connect_jwks#show'

  get 'caf/famille' => '/api_particulier/v2/cnaf/quotient_familial#show'
  get 'impots/svair', to: svair_gone

  get 'open-api.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/api_particulier_open_api_static/v2.yaml'))]] }
  get 'open-api-v2.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/api_particulier_open_api_static/v2.yaml'))]] }
  get 'open-api-v3.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/openapi-particulier.yaml'))]] }
  get 'france-connect/open-api.yml', to: ->(env) { [200, {}, [File.read(Rails.root.join('swagger/api_particulier_open_api_static/v2.yaml'))]] }

  namespace '/v2' do
    get 'composition-familiale', to: qf_v1_gone

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
