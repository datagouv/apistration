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
    namespace :mi do
      get 'associations/:siret_or_rna' => '/api/v3_and_more/mi/associations#show'
    end

    namespace :rnm do
      get 'entreprises/:siren' => '/api/v3_and_more/rnm/entreprises_artisanales#show'
    end

    namespace :probtp do
      get 'attestations_cotisation_retraite/:siret' => '/api/v3_and_more/probtp/attestations_cotisation_retraite#show'
    end

    namespace :acoss do
      get 'attestations_sociales/:siren' => '/api/v3_and_more/acoss/attestations_sociales#show'
    end

    namespace :insee do
      get 'entreprises/:siren' => '/api/v3_and_more/insee/entreprises#show'
      get 'entreprises/diffusables/:siren' => '/api/v3_and_more/insee/entreprises_diffusables#show'
    end
  end

  mount Rswag::Ui::Engine   => '/developers'
  mount Rswag::Api::Engine  => '/'
end
