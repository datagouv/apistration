Rails.application.routes.draw do
  namespace :v2, constraints: APIEntrepriseDomainConstraint.new  do
    get 'uptime' => '/api_entreprise/v2/uptime#show'

    get 'effectifs_annuels_acoss_covid/:siren'                              => '/api_entreprise/v2/effectifs_annuels_entreprise_acoss_covid#show'
    get 'effectifs_mensuels_acoss_covid/:annee/:mois/etablissement/:siret'  => '/api_entreprise/v2/effectifs_mensuels_etablissement_acoss_covid#show'
    get 'effectifs_mensuels_acoss_covid/:annee/:mois/entreprise/:siren'     => '/api_entreprise/v2/effectifs_mensuels_entreprise_acoss_covid#show'

    get 'exercices/:siret'                                  => '/api_entreprise/v2/exercices#show'

    get 'cotisations_msa/:siret'                            => '/api_entreprise/v2/cotisations_msa#show'

    get 'cartes_professionnelles_fntp/:siren'               => '/api_entreprise/v2/cartes_professionnelles_fntp#show'

    get 'certificats_opqibi/:siren'                         => '/api_entreprise/v2/certificats_opqibi#show'
    get 'certificats_agence_bio/:siret'                     => '/api_entreprise/v2/certificats_agence_bio#show'

    get 'liasses_fiscales_dgfip/:annee/complete/:siren'     => '/api_entreprise/v2/liasses_fiscales_dgfip#show'
    get 'liasses_fiscales_dgfip/:annee/declarations/:siren' => '/api_entreprise/v2/liasses_fiscales_dgfip#declaration'
    get 'liasses_fiscales_dgfip/:annee/dictionnaire'        => '/api_entreprise/v2/liasses_fiscales_dgfip#dictionnaire'
    get 'attestations_fiscales_dgfip/:siren'                => '/api_entreprise/v2/attestations_fiscales_dgfip#show'

    get 'attestations_sociales_acoss/:siren'                => '/api_entreprise/v2/attestations_sociales_acoss#show'

    get 'attestations_agefiph/:siret'                       => '/api_entreprise/v2/attestations_agefiph#show'

    get 'conventions_collectives/:siret'                    => '/api_entreprise/v2/conventions_collectives#show'

    get 'entreprises_artisanales_cma/:siren'                => '/api_entreprise/v2/entreprises_artisanales#show'

    get 'eligibilites_cotisation_retraite_probtp/:siret'    => '/api_entreprise/v2/eligibilites_cotisation_retraite_probtp#show'
    get 'attestations_cotisation_retraite_probtp/:siret'    => '/api_entreprise/v2/attestations_cotisation_retraite_probtp#show'

    get 'certificats_qualibat/:siret'                       => '/api_entreprise/v2/certificats_qualibat#show'
    get 'extraits_rcs_infogreffe/:siren'                    => '/api_entreprise/v2/extraits_rcs_infogreffe#show'

    get 'associations/:id'                                  => '/api_entreprise/v2/associations#show'
    get 'documents_associations/:id'                        => '/api_entreprise/v2/documents_associations#show'

    get 'certificats_cnetp/:siren'                          => '/api_entreprise/v2/certificats_cnetp#show'

    get 'certificats_rge_ademe/:siret'                      => '/api_entreprise/v2/certificats_rge_ademe#show'

    get 'extraits_courts_inpi/:siren'                       => '/api_entreprise/v2/extraits_courts_inpi#show'
    get 'actes_inpi/:siren'                                 => '/api_entreprise/v2/documents_inpi#actes'
    get 'bilans_inpi/:siren'                                => '/api_entreprise/v2/documents_inpi#bilans'

    get 'bilans_entreprises_bdf/:siren'                     => '/api_entreprise/v2/bilans_entreprises_bdf#show'

    get 'privileges'                                        => '/api_entreprise/v2/privileges#show'

    get 'entreprises/:siren'                                => '/api_entreprise/v2/entreprises_restored#show'
    get 'etablissements/:siret'                             => '/api_entreprise/v2/etablissements_restored#show'

    get 'eori_douanes/:siret_or_eori'                       => '/api_entreprise/v2/eori_douanes#show'

    get 'openapi.yaml', to: ->(env) { [200, {}, [File.read(Rails.root.join('public/v2/open-api.yml'))]] }
  end

  scope path: 'v:api_version', constraints: APIEntrepriseDomainConstraint.new(v3_and_more: true) do
    get 'ping', to: 'api_entreprise/ping#show'

    get 'urssaf/unites_legales/:siren/attestation_vigilance', to: 'api_entreprise/v3_and_more/acoss/attestations_sociales#show'

    namespace :ademe do
      get 'etablissements/:siret/certification_rge' => '/api_entreprise/v3_and_more/ademe/certificats_rge#show'
    end

    namespace :cnetp do
      get 'unites_legales/:siren/attestation_cotisations_conges_payes_chomage_intemperies' => '/api_entreprise/v3_and_more/cnetp/attestation_cotisations_conges_payes_chomage_intemperies#show'
    end

    get 'douanes/etablissements/:siret_or_eori/immatriculations_eori', to: 'api_entreprise/v3_and_more/dgddi/eori#show'

    namespace :dgfip do
      get 'unites_legales/:siren/liasses_fiscales/:year' => '/api_entreprise/v3_and_more/dgfip/liasses_fiscales/declarations#show'
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
      get 'unites_legales/:siren/actes' => '/api_entreprise/v3_and_more/inpi/actes#show'

      get 'unites_legales/:siren/brevets' => '/api_entreprise/v3_and_more/inpi/latest_brevets#show'
      get 'unites_legales/:siren/marques' => '/api_entreprise/v3_and_more/inpi/latest_marques#show'
      get 'unites_legales/:siren/modeles' => '/api_entreprise/v3_and_more/inpi/latest_modeles#show'
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
    end

    namespace :infogreffe do
      get 'rcs/unites_legales/:siren/mandataires_sociaux' => '/api_entreprise/v3_and_more/infogreffe/mandataires_sociaux#show'
      get 'rcs/unites_legales/:siren/extrait_kbis' => '/api_entreprise/v3_and_more/infogreffe/extraits_rcs#show'
    end

    get 'ministere_interieur/rna/associations/:siret_or_rna', to: 'api_entreprise/v3_and_more/mi/associations#show'
    get 'ministere_interieur/rna/associations/:siret_or_rna/documents', to: 'api_entreprise/v3_and_more/mi/documents_associations#show'

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

    get 'cma_france/rnm/unites_legales/:siren', to: 'api_entreprise/v3_and_more/rnm/entreprises_artisanales#show'
  end

  mount Rswag::Api::Engine  => '/v3', constraints: APIEntrepriseDomainConstraint.new
end
