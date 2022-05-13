Rails.application.routes.draw do
  namespace :v2 do
    get 'uptime' => '/api/v2/uptime#show'

    # COVID
    get 'effectifs_annuels_acoss_covid/:siren'                              => '/api/v2/effectifs_annuels_entreprise_acoss_covid#show'
    get 'effectifs_mensuels_acoss_covid/:annee/:mois/etablissement/:siret'  => '/api/v2/effectifs_mensuels_etablissement_acoss_covid#show'
    get 'effectifs_mensuels_acoss_covid/:annee/:mois/entreprise/:siren'     => '/api/v2/effectifs_mensuels_entreprise_acoss_covid#show'

    # LEGACY from v1
    get 'entreprises_legacy/:siren' => '/api/v2/entreprises_legacy#show'
    get 'etablissements_legacy/:siret' => '/api/v2/etablissements_legacy#show'
    # LEGACY from v1

    get 'etablissements/:siret/predecesseur'                => '/api/v2/etablissements/predecesseur#show'
    get 'etablissements/:siret/successeur'                  => '/api/v2/etablissements/successeur#show'

    get 'exercices/:siret'                                  => '/api/v2/exercices#show'

    get 'cotisations_msa/:siret'                            => '/api/v2/cotisations_msa#show'

    get 'cartes_professionnelles_fntp/:siren'               => '/api/v2/cartes_professionnelles_fntp#show'

    get 'certificats_opqibi/:siren'                         => '/api/v2/certificats_opqibi#show'
    get 'certificats_agence_bio/:siret'                     => '/api/v2/certificats_agence_bio#show'

    get 'liasses_fiscales_dgfip/:annee/complete/:siren'     => '/api/v2/liasses_fiscales_dgfip#show'
    get 'liasses_fiscales_dgfip/:annee/declarations/:siren' => '/api/v2/liasses_fiscales_dgfip#declaration'
    get 'liasses_fiscales_dgfip/:annee/dictionnaire'        => '/api/v2/liasses_fiscales_dgfip#dictionnaire'
    get 'attestations_fiscales_dgfip/:siren'                => '/api/v2/attestations_fiscales_dgfip#show'

    get 'attestations_sociales_acoss/:siren'                => '/api/v2/attestations_sociales_acoss#show'

    get 'attestations_agefiph/:siret'                       => '/api/v2/attestations_agefiph#show'

    get 'conventions_collectives/:siret'                    => '/api/v2/conventions_collectives#show'

    get 'entreprises_artisanales_cma/:siren'                => '/api/v2/entreprises_artisanales#show'

    get 'eligibilites_cotisation_retraite_probtp/:siret'    => '/api/v2/eligibilites_cotisation_retraite_probtp#show'
    get 'attestations_cotisation_retraite_probtp/:siret'    => '/api/v2/attestations_cotisation_retraite_probtp#show'

    get 'certificats_qualibat/:siret'                       => '/api/v2/certificats_qualibat#show'
    get 'extraits_rcs_infogreffe/:siren'                    => '/api/v2/extraits_rcs_infogreffe#show'

    get 'associations/:id'                                  => '/api/v2/associations#show'
    get 'documents_associations/:id'                        => '/api/v2/documents_associations#show'

    get 'certificats_cnetp/:siren'                          => '/api/v2/certificats_cnetp#show'

    get 'certificats_rge_ademe/:siret'                      => '/api/v2/certificats_rge_ademe#show'

    get 'extraits_courts_inpi/:siren'                       => '/api/v2/extraits_courts_inpi#show'
    get 'actes_inpi/:siren'                                 => '/api/v2/documents_inpi#actes'
    get 'bilans_inpi/:siren'                                => '/api/v2/documents_inpi#bilans'

    get 'bilans_entreprises_bdf/:siren'                     => '/api/v2/bilans_entreprises_bdf#show'

    get 'privileges'                                        => '/api/v2/privileges#show'

    get 'entreprises/:siren'                                => '/api/v2/entreprises_restored#show'
    get 'etablissements/:siret'                             => '/api/v2/etablissements_restored#show'

    get 'eori_douanes/:siret_or_eori'                       => '/api/v2/eori_douanes#show'
  end

  scope path: 'v:api_version', constraints: { api_version: /\d+/ } do
    get 'urssaf/unites_legales/:siren/attestation_vigilance', to: 'api/v3_and_more/acoss/attestations_sociales#show'

    namespace :ademe do
      get 'etablissements/:siret/certification_rge' => '/api/v3_and_more/ademe/certificats_rge#show'
    end

    namespace :cnetp do
      get 'unites_legales/:siren/attestation_cotisations_conges_payes_chomage_intemperies' => '/api/v3_and_more/cnetp/attestation_cotisations_conges_payes_chomage_intemperies#show'
    end

    get 'douanes/etablissements/:siret_or_eori/immatriculations_eori', to: 'api/v3_and_more/dgddi/eori#show'

    namespace :dgfip do
      get 'unites_legales/:siren/liasses_fiscales/:year' => '/api/v3_and_more/dgfip/liasses_fiscales/declarations#show'
      get 'etablissements/:siret/chiffres_affaires' => '/api/v3_and_more/dgfip/chiffres_affaires#show'
      get 'unites_legales/:siren/attestation_fiscale' => '/api/v3_and_more/dgfip/attestations_fiscales#show'
    end

    namespace :fabrique_numerique_ministeres_sociaux do
      get 'etablissements/:siret/conventions_collectives' => '/api/v3_and_more/fabrique_numerique_ministeres_sociaux/conventions_collectives#show'
    end

    namespace :fntp do
      get 'unites_legales/:siren/carte_professionnelle_travaux_publics' => '/api/v3_and_more/fntp/carte_professionnelle_travaux_publics#show'
    end

    namespace :inpi do
      get 'unites_legales/:siren/actes' => '/api/v3_and_more/inpi/actes#show'

      get 'unites_legales/:siren/brevets' => '/api/v3_and_more/inpi/latest_brevets#show'
      get 'unites_legales/:siren/marques' => '/api/v3_and_more/inpi/latest_marques#show'
      get 'unites_legales/:siren/modeles' => '/api/v3_and_more/inpi/latest_modeles#show'
    end

    namespace :insee do
      get 'sirene/unites_legales/:siren' => '/api/v3_and_more/insee/unites_legales#show'
      get 'sirene/unites_legales/diffusibles/:siren' => '/api/v3_and_more/insee/unites_legales_diffusables#show'

      get 'sirene/unites_legales/:siren/siege_social' => '/api/v3_and_more/insee/sieges_unites_legales#show'
      get 'sirene/unites_legales/diffusibles/:siren/siege_social' => '/api/v3_and_more/insee/sieges_diffusables_unites_legales#show'

      get 'sirene/etablissements/:siret' => '/api/v3_and_more/insee/etablissements#show'
      get 'sirene/etablissements/diffusibles/:siret' => '/api/v3_and_more/insee/etablissements_diffusables#show'

      get 'sirene/etablissements/:siret/adresse' => '/api/v3_and_more/insee/adresses_etablissements#show'
      get 'sirene/etablissements/diffusibles/:siret/adresse' => '/api/v3_and_more/insee/adresses_etablissements_diffusables#show'
    end

    namespace :infogreffe do
      get 'unites_legales/:siren/mandataires_sociaux' => '/api/v3_and_more/infogreffe/mandataires_sociaux#show'
      get 'rcs/unites_legales/:siren/extrait_kbis' => '/api/v3_and_more/infogreffe/extraits_rcs#show'
    end

    get 'ministere_interieur/rna/associations/:siret_or_rna', to: 'api/v3_and_more/mi/associations#show'
    get 'ministere_interieur/rna/associations/:siret_or_rna/documents', to: 'api/v3_and_more/mi/documents_associations#show'

    namespace :msa do
      get 'etablissements/:siret/conformite_cotisations' => '/api/v3_and_more/msa/conformites_cotisations#show'
    end

    namespace :opqibi do
      get 'unites_legales/:siren/certification_ingenierie' => '/api/v3_and_more/opqibi/certifications_ingenierie#show'
    end

    namespace :probtp do
      get 'etablissements/:siret/attestation_cotisations_retraite' => '/api/v3_and_more/probtp/attestations_cotisation_retraite#show'
      get 'etablissements/:siret/conformite_cotisations_retraite' => '/api/v3_and_more/probtp/conformites_cotisations_retraite#show'
    end

    namespace :qualibat do
      get 'etablissements/:siret/certification_batiment' => '/api/v3_and_more/qualibat/certifications_batiment#show'
    end

    get 'cma_france/rnm/unites_legales/:siren', to: 'api/v3_and_more/rnm/entreprises_artisanales#show'
  end

  mount Rswag::Ui::Engine   => '/v3/developers'
  mount Rswag::Api::Engine  => '/v3'
end
