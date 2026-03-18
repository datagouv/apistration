class SIADE::V3::Drivers::INSEE::Entreprise < SIADE::V2::Drivers::GenericDriver
  default_to_nil_raw_fetching_methods :siren,
                                      :nic_siege_social,
                                      :siret_siege_social,
                                      :date_creation,
                                      :date_dernier_traitement,
                                      :raison_sociale,
                                      :diffusable_commercialement,
                                      :sigle,
                                      :etat_administratif,
                                      :date_cessation,
                                      :economie_sociale_et_solidaire,
                                      :id_rna,
                                      :sexe,
                                      :nom,
                                      :nom_usage,
                                      :prenom_1,
                                      :prenom_2,
                                      :prenom_3,
                                      :prenom_4,
                                      :prenom_usuel,
                                      :pseudonyme,
                                      :categorie_juridique,
                                      :activite_principale,
                                      :tranche_effectif_salarie,
                                      :categorie_entreprise,
                                      :annee_categorie_entreprise,
                                      :caractere_employeur,
                                      :nombre_periodes,
                                      :periodes

  def initialize(siren:)
    @siren = siren
  end

  def provider_name
    'INSEE'
  end

  def request
    @request ||= SIADE::V3::Requests::INSEE::Entreprise.new(@siren)
  end

  def check_response; end

  private

  def info_entreprise
    @info_entreprise ||= JSON.parse(response.body).deep_symbolize_keys[:uniteLegale]
  end

  def info_entreprise_actuel
    @info_entreprise_actuel ||= info_entreprise[:periodesUniteLegale].first
  end

  def nic_siege_social_raw
    info_entreprise_actuel[:nicSiegeUniteLegale]
  end

  def siren_raw
    info_entreprise[:siren]
  end

  def siret_siege_social_raw
    info_entreprise[:siren] + info_entreprise_actuel[:nicSiegeUniteLegale]
  end

  def raison_sociale_raw
    info_entreprise_actuel[:denominationUniteLegale]
  end

  def diffusable_commercialement_raw
    yes_no_to_boolean(info_entreprise[:statutDiffusionUniteLegale])
  end

  def sigle_raw
    info_entreprise[:sigleUniteLegale]
  end

  def economie_sociale_et_solidaire_raw
    info_entreprise_actuel[:economieSocialeSolidaireUniteLegale]
  end

  def id_rna_raw
    info_entreprise[:identifiantAssociationUniteLegale]
  end

  def sexe_raw
    info_entreprise[:sexeUniteLegale]
  end

  def nom_raw
    info_entreprise_actuel[:nomUniteLegale]
  end

  def nom_usage_raw
    info_entreprise_actuel[:nomUsageUniteLegale]
  end

  def prenom_1_raw
    info_entreprise[:prenom1UniteLegale]
  end

  def prenom_2_raw
    info_entreprise[:prenom2UniteLegale]
  end

  def prenom_3_raw
    info_entreprise[:prenom3UniteLegale]
  end

  def prenom_4_raw
    info_entreprise[:prenom4UniteLegale]
  end

  def prenom_usuel_raw
    info_entreprise[:prenomUsuelUniteLegale]
  end

  def pseudonyme_raw
    info_entreprise[:pseudonymeUniteLegale]
  end

  def categorie_juridique_raw
    SIADE::V3::Referentials::CategorieJuridique.new(
      code: info_entreprise_actuel[:categorieJuridiqueUniteLegale]
    )
  end

  def activite_principale_raw
    @activite_principale ||= SIADE::V3::Referentials::ActivitePrincipale.new(
      code:         info_entreprise_actuel[:activitePrincipaleUniteLegale],
      nomenclature: info_entreprise_actuel[:nomenclatureActivitePrincipaleUniteLegale]
    )
  end

  def tranche_effectif_salarie_raw
    SIADE::V3::Referentials::TrancheEffectifSalarie.new(
      code:           info_entreprise[:trancheEffectifsUniteLegale],
      date_reference: info_entreprise[:anneeEffectifsUniteLegale]
    )
  end

  def categorie_entreprise_raw
    info_entreprise[:categorieEntreprise]
  end

  def annee_categorie_entreprise_raw
    info_entreprise[:anneeCategorieEntreprise]
  end

  def caractere_employeur_raw
    info_entreprise_actuel[:caractereEmployeurUniteLegale]
  end

  def nombre_periodes_raw
    info_entreprise[:nombrePeriodesUniteLegale]
  end

  def date_creation_raw
    nullable_date_to_timestamp info_entreprise[:dateCreationUniteLegale]
  end

  def date_dernier_traitement_raw
    nullable_date_to_timestamp info_entreprise[:dateDernierTraitementUniteLegale]
  end

  def date_cessation_raw
    nullable_date_to_timestamp info_entreprise_actuel[:dateDebut] if etat_administratif == 'C'
  end

  def etat_administratif_raw
    info_entreprise_actuel[:etatAdministratifUniteLegale]
  end

  def periodes_raw
    @periodes_raw ||= info_entreprise[:periodesUniteLegale].map do |periode|
      date_debut = nullable_date_to_timestamp periode[:dateDebut]
      date_fin = nullable_date_to_timestamp periode[:dateFin]

      {
        date_fin:                                  date_fin,
        date_debut:                                date_debut,
        nom:                                       periode[:nomUniteLegale],
        changement_nom?:                           periode[:changementNomUniteLegale],
        nom_usage:                                 periode[:nomUsageUniteLegale],
        changement_nom_usage?:                     periode[:changementNomUsageUniteLegale],
        raison_sociale:                            periode[:denominationUniteLegale],
        changement_raison_sociale?:                periode[:changementDenominationUniteLegale],
        raison_sociale_usuelle_1:                  periode[:denominationUsuelle1UniteLegale],
        raison_sociale_usuelle_2:                  periode[:denominationUsuelle2UniteLegale],
        raison_sociale_usuelle_3:                  periode[:denominationUsuelle3UniteLegale],
        changement_raison_sociale_usuelle?:        periode[:changementDenominationUsuelleUniteLegale],
        etat_administratif:                        periode[:etatAdministratifUniteLegale],
        changement_etat_administratif?:            periode[:changementEtatAdministratifUniteLegale],
        economie_sociale_et_solidaire:             periode[:economieSocialeSolidaireUniteLegale],
        changement_economie_sociale_et_solidaire?: periode[:changementEconomieSocialeSolidaireUniteLegale],
        nic_siege_social:                          periode[:nicSiegeUniteLegale],
        changement_nic_siege_social?:              periode[:changementNicSiegeUniteLegale],
        code_forme_juridique:                      periode[:categorieJuridiqueUniteLegale],
        changement_forme_juridique?:               periode[:changementCategorieJuridiqueUniteLegale],
        caractere_employeur:                       periode[:caractereEmployeurUniteLegale],
        changement_caractere_employeur?:           periode[:changementCaractereEmployeurUniteLegale],
        code_naf:                                  periode[:activitePrincipaleUniteLegale],
        nomenclature_naf:                          periode[:nomenclatureActivitePrincipaleUniteLegale],
        changement_naf?:                           periode[:changementActivitePrincipaleUniteLegale]
      }
    end
  end

  def nullable_date_to_timestamp(date)
    Time.zone.parse(date).to_i unless date.nil?
  end

  def yes_no_to_boolean(value)
    # nil if nil && true/false if O/N
    value && value == 'O'
  end
end
