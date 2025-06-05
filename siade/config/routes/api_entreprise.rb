actes_gone = lambda do |env|
  [410, {}, ['Cette route a été déplacée. Merci de mettre à jour votre application vers la nouvelle route. Vous pouvez consulter la documentation à l\'adresse suivante: https://entreprise.api.gouv.fr/catalogue/inpi/rne/actes_bilans']]
end

generic_gone = lambda do |env|
  [410, {}, ['Cette route n\'existe plus sur API Entreprise. Vous pouvez consulter la liste des routes sur notre documentation OpenAPI: https://entreprise.api.gouv.fr/developpeurs/openapi']]
end

get '/v2/ping' => 'ping#show', constraints: APIEntrepriseDomainConstraint.new
get '/v:api_version/ping' => 'ping#show', constraints: APIEntrepriseDomainConstraint.new(v3_and_more: true)

get '/v2/privileges' => 'api_entreprise/privileges#index', constraints: APIEntrepriseDomainConstraint.new

match '/v2/*whatever', to: 'errors#gone', via: :all, constraints: APIEntrepriseDomainConstraint.new

scope path: 'v:api_version', constraints: APIEntrepriseDomainConstraint.new(v3_and_more: true) do
  get 'urssaf/unites_legales/:siren/attestation_vigilance', to: 'api_entreprise/v3_and_more/acoss/attestations_sociales#show'

  namespace :ademe do
    get 'etablissements/:siret/certification_rge' => '/api_entreprise/v3_and_more/ademe/certificats_rge#show'
  end

  namespace :carif_oref do
    get 'etablissements/:siret/certifications_qualiopi_france_competences' => '/api_entreprise/v3_and_more/carif_oref/certifications_qualiopi_france_competences#show'
  end

  namespace :cibtp do
    get 'etablissements/:siret/attestation_cotisations_conges_payes_chomage_intemperies' => '/api_entreprise/v3_and_more/cibtp/attestation_cotisations_conges_payes_chomage_intemperies#show'
  end

  namespace :cnetp do
    get 'unites_legales/:siren/attestation_cotisations_conges_payes_chomage_intemperies' => '/api_entreprise/v3_and_more/cnetp/attestation_cotisations_conges_payes_chomage_intemperies#show'
  end

  get 'douanes/etablissements/:siret_or_eori/immatriculations_eori', to: 'api_entreprise/v3_and_more/dgddi/eori#show'

  namespace :dgfip do
    get 'unites_legales/:siren/liasses_fiscales/:year' => '/api_entreprise/v3_and_more/dgfip/liasses_fiscales#show'
    get 'unites_legales/:siren/liens_capitalistiques/:year' => '/api_entreprise/v3_and_more/dgfip/liens_capitalistiques#show'
    get 'etablissements/:siret/chiffres_affaires' => '/api_entreprise/v3_and_more/dgfip/chiffres_affaires#show'
    get 'unites_legales/:siren/attestation_fiscale' => '/api_entreprise/v3_and_more/dgfip/attestations_fiscales#show'
  end

  namespace :fabrique_numerique_ministeres_sociaux do
    get 'etablissements/:siret/conventions_collectives' => '/api_entreprise/v3_and_more/fabrique_numerique_ministeres_sociaux/conventions_collectives#show'
  end

  namespace :fntp do
    get 'unites_legales/:siren/carte_professionnelle_travaux_publics' => '/api_entreprise/v3_and_more/fntp/carte_professionnelle_travaux_publics#show'
  end

  namespace :inpi do
    get 'unites_legales/:siren/actes', to: actes_gone

    get 'unites_legales/:siren/brevets', to: generic_gone
    get 'unites_legales/:siren/marques', to: generic_gone
    get 'unites_legales/:siren/modeles', to: generic_gone

    namespace :rne do
      get 'unites_legales/open_data/:siren/beneficiaires_effectifs' => '/api_entreprise/v3_and_more/inpi/rne/beneficiaires_effectifs_open_data#show'
      get 'unites_legales/:siren/beneficiaires_effectifs' => '/api_entreprise/v3_and_more/inpi/rne/beneficiaires_effectifs#show'

      get 'unites_legales/open_data/:siren/actes_bilans' => '/api_entreprise/v3_and_more/inpi/rne/actes_bilans#show'
    end
  end

  namespace :insee do
    get 'sirene/unites_legales/:siren' => '/api_entreprise/v3_and_more/insee/unites_legales#show'
    get 'sirene/unites_legales/diffusibles/:siren' => '/api_entreprise/v3_and_more/insee/unites_legales_diffusables#show'

    get 'sirene/unites_legales/:siren/siege_social' => '/api_entreprise/v3_and_more/insee/sieges_unites_legales#show'
    get 'sirene/unites_legales/diffusibles/:siren/siege_social' => '/api_entreprise/v3_and_more/insee/sieges_diffusables_unites_legales#show'

    get 'sirene/etablissements/:siret' => '/api_entreprise/v3_and_more/insee/etablissements#show'
    get 'sirene/etablissements/diffusibles/:siret' => '/api_entreprise/v3_and_more/insee/etablissements_diffusables#show'

    get 'sirene/etablissements/:siret/adresse' => '/api_entreprise/v3_and_more/insee/adresses_etablissements#show'
    get 'sirene/etablissements/diffusibles/:siret/adresse' => '/api_entreprise/v3_and_more/insee/adresses_etablissements_diffusables#show'

    get 'sirene/etablissements/:siret/successions' => '/api_entreprise/v3_and_more/insee/successions#show'
  end

  namespace :infogreffe do
    get 'rcs/unites_legales/:siren/mandataires_sociaux' => '/api_entreprise/v3_and_more/infogreffe/mandataires_sociaux#show'
    get 'rcs/unites_legales/:siren/extrait_kbis' => '/api_entreprise/v3_and_more/infogreffe/extraits_rcs#show'
  end

  get 'ministere_interieur/rna/associations/:siret_or_rna', to: 'api_entreprise/v3_and_more/mi/associations#show'
  get 'ministere_interieur/rna/associations/:siret_or_rna/documents', to: 'api_entreprise/v3_and_more/mi/documents_associations#show'

  get 'ministere_interieur/api-association/associations/:siren_or_rna', to: 'api_entreprise/v3_and_more/mi/unites_legales#show'
  get 'ministere_interieur/api-association/associations/open_data/:siren_or_rna', to: 'api_entreprise/v3_and_more/mi/unites_legales_open_data#show'

  get 'djepva/api-association/associations/:siren_or_rna', to: 'api_entreprise/v3_and_more/mi/unites_legales#show'
  get 'djepva/api-association/associations/open_data/:siren_or_rna', to: 'api_entreprise/v3_and_more/mi/unites_legales_open_data#show'

  get 'data_subvention/subventions/:siren_or_siret_or_rna', to: 'api_entreprise/v3_and_more/data_subvention/subventions#show'

  namespace :msa do
    get 'etablissements/:siret/conformite_cotisations' => '/api_entreprise/v3_and_more/msa/conformites_cotisations#show'
  end

  namespace :opqibi do
    get 'unites_legales/:siren/certification_ingenierie' => '/api_entreprise/v3_and_more/opqibi/certifications_ingenierie#show'
  end

  namespace :probtp do
    get 'etablissements/:siret/attestation_cotisations_retraite' => '/api_entreprise/v3_and_more/probtp/attestations_cotisation_retraite#show'
    get 'etablissements/:siret/conformite_cotisations_retraite' => '/api_entreprise/v3_and_more/probtp/conformites_cotisations_retraite#show'
  end

  namespace :qualibat do
    get 'etablissements/:siret/certification_batiment' => '/api_entreprise/v3_and_more/qualibat/certifications_batiment#show'
  end

  namespace :qualifelec do
    get 'etablissements/:siret/certificats' => '/api_entreprise/v3_and_more/qualifelec/certificats#show'
  end

  get 'cma_france/rnm/unites_legales/:siren', to: 'api_entreprise/v3_and_more/rnm/entreprises_artisanales#show'

  get 'european_commission/unites_legales/:siren/numero_tva', to: 'api_entreprise/v3_and_more/european_commission/vies#show'

  get 'banque_de_france/unites_legales/:siren/bilans', to: 'api_entreprise/v3_and_more/banque_de_france/bilans_entreprise#show'

  namespace :gip_mds do
    get 'unites_legales/:siren/effectifs_annuels/:year', to: '/api_entreprise/v3_and_more/gip_mds/effectifs_annuels_entreprise#show'
    get 'etablissements/:siret/effectifs_mensuels/:month/annee/:year', to: '/api_entreprise/v3_and_more/gip_mds/effectifs_mensuels_etablissement#show'
  end
end

get 'proxy/files/:uuid', to: 'api_entreprise/proxied_files#show', constraints: APIEntrepriseDomainConstraint.new
get 'proxy/inpi/download/:uuid', to: 'api_entreprise/inpi_proxy#show', constraints: APIEntrepriseDomainConstraint.new
get 'ping/*provider_with_source', to: 'api_entreprise/ping_providers#show', as: 'api_entreprise_ping_provider', constraints: APIEntrepriseDomainConstraint.new
get 'pings', to: 'api_entreprise/ping_providers#index', as: 'api_entreprise_ping_providers', constraints: APIEntrepriseDomainConstraint.new
get 'privileges', to: 'api_entreprise/privileges#index', as: 'api_entreprise_privileges', constraints: APIEntrepriseDomainConstraint.new

mount Rswag::Api::Engine => '/v3', constraints: APIEntrepriseDomainConstraint.new
