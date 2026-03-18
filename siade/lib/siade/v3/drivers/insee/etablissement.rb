class SIADE::V3::Drivers::INSEE::Etablissement < SIADE::V2::Drivers::GenericDriver
  default_to_nil_raw_fetching_methods :siret,
                                      :siege_social,
                                      :siren,
                                      :nic,
                                      :raison_sociale,
                                      :etat_administratif,
                                      :date_fermeture,
                                      :diffusable_commercialement,
                                      :date_creation,
                                      :date_dernier_traitement,
                                      :activite_princiaple_registre_metiers,
                                      :enseigne_1,
                                      :enseigne_2,
                                      :enseigne_3,
                                      :enseignes,
                                      :activite_principale,
                                      :caractere_employeur,
                                      :adresse,
                                      :tranche_effectif_salarie,
                                      :nombre_periodes_etablissement,
                                      :periodes_etablissement,
                                      :entreprise

  def initialize(siret:)
    @siret = siret
  end

  def provider_name
    'INSEE'
  end

  def request
    @request ||= SIADE::V3::Requests::INSEE::Etablissement.new(@siret)
  end

  def check_response; end

  def adresse_francaise?
    !info_etab[:adresseEtablissement][:codeCommuneEtablissement].nil? && info_etab[:adresseEtablissement][:codePaysEtrangerEtablissement].nil?
  end

  def siret_redirected_to_another_siret?
    # instead of expected key etablissement (without 's')
    json_response.has_key?(:etablissements)
  end

  private

  def json_response
    @json_response ||= JSON.parse(response.body).deep_symbolize_keys
  end

  def info_etab
    json_response[:etablissement]
  end

  def info_etab_actuel
    info_etab[:periodesEtablissement].first
  end

  def siret_raw
    json_response.dig(:etablissement, :siret) ||
      json_response[:etablissements].first[:siret]
  end

  def siege_social_raw
    info_etab[:etablissementSiege]
  end

  def siren_raw
    info_etab[:siren]
  end

  def nic_raw
    info_etab[:nic]
  end

  def raison_sociale_raw
    info_etab_actuel[:denominationUsuelleEtablissement]
  end

  def diffusable_commercialement_raw
    yes_no_to_boolean(info_etab[:statutDiffusionEtablissement])
  end

  def tranche_effectif_salarie_raw
    SIADE::V3::Referentials::TrancheEffectifSalarie.new(
      code:           info_etab[:trancheEffectifsEtablissement],
      date_reference: info_etab[:anneeEffectifsEtablissement]
    )
  end

  def activite_princiaple_registre_metiers_raw
    info_etab[:activitePrincipaleRegistreMetiersEtablissement]
  end

  def activite_principale_raw
    @activite_principale ||= SIADE::V3::Referentials::ActivitePrincipale.new(
      code:         info_etab_actuel[:activitePrincipaleEtablissement],
      nomenclature: info_etab_actuel[:nomenclatureActivitePrincipaleEtablissement]
    )
  end

  def caractere_employeur_raw
    info_etab_actuel[:caractereEmployeurEtablissement]
  end

  def enseigne_1_raw
    info_etab_actuel[:enseigne1Etablissement]
  end

  def enseigne_2_raw
    info_etab_actuel[:enseigne2Etablissement]
  end

  def enseigne_3_raw
    info_etab_actuel[:enseigne3Etablissement]
  end

  def enseignes_raw
    enseignes = [
      info_etab_actuel[:enseigne1Etablissement],
      info_etab_actuel[:enseigne2Etablissement],
      info_etab_actuel[:enseigne3Etablissement]
    ]
      .compact
      .delete_if(&:empty?)
      .join(', ')

    enseignes.empty? ? nil : enseignes
  end

  def date_creation_raw
    nullable_date_to_timestamp info_etab[:dateCreationEtablissement]
  end

  def date_dernier_traitement_raw
    nullable_date_to_timestamp info_etab[:dateDernierTraitementEtablissement]
  end

  def date_fermeture_raw
    nullable_date_to_timestamp info_etab_actuel[:dateDebut] if etat_administratif == 'F'
  end

  def etat_administratif_raw
    info_etab_actuel[:etatAdministratifEtablissement]
  end

  def adresse_raw
    adresse = info_etab[:adresseEtablissement]

    @adresse ||= {
      adresse_francaise?:       adresse_francaise?,
      complement_adresse:       adresse[:complementAdresseEtablissement],
      numero_voie:              adresse[:numeroVoieEtablissement],
      indice_repetition:        adresse[:indiceRepetitionEtablissement],
      type_voie:                adresse[:typeVoieEtablissement],
      libelle_voie:             adresse[:libelleVoieEtablissement],
      code_postal:              adresse[:codePostalEtablissement],
      code_commune:             adresse[:codeCommuneEtablissement],
      libelle_commune:          adresse[:libelleCommuneEtablissement],
      libelle_commune_etranger: adresse[:libelleCommuneEtrangerEtablissement],
      distribution_speciale:    adresse[:distributionSpecialeEtablissement],
      code_cedex:               adresse[:codeCedexEtablissement],
      libelle_cedex:            adresse[:libelleCedexEtablissement],
      code_pays_etranger:       adresse[:codePaysEtrangerEtablissement],
      libelle_pays_etranger:    adresse[:libellePaysEtrangerEtablissement]
    }
  end

  def nombre_periodes_etablissement_raw
    periodes_etablissement_raw.size
  end

  def periodes_etablissement_raw
    @periodes_etablissement_raw ||= info_etab[:periodesEtablissement].map do |periode|
      date_debut = nullable_date_to_timestamp periode[:dateDebut]
      date_fin =  nullable_date_to_timestamp periode[:dateFin]

      {
        date_fin:                        date_fin,
        date_debut:                      date_debut,
        etat_administratif:              periode[:etatAdministratifEtablissement],
        changement_etat_administratif?:  periode[:changementEtatAdministratifEtablissement],
        enseigne_1:                      periode[:enseigne1Etablissement],
        enseigne_2:                      periode[:enseigne2Etablissement],
        enseigne_3:                      periode[:enseigne3Etablissement],
        changement_enseigne?:            periode[:changementEnseigneEtablissement],
        code_naf:                        periode[:activitePrincipaleEtablissement],
        nomenclature_naf:                periode[:nomenclatureActivitePrincipaleEtablissement],
        changement_naf?:                 periode[:changementActivitePrincipaleEtablissement],
        caractere_employeur:             periode[:caractereEmployeurEtablissement],
        changement_caractere_employeur?: periode[:changementCaractereEmployeurEtablissement]
      }
    end
  end

  def info_entreprise
    info_etab[:uniteLegale]
  end

  def entreprise_raw
    @entreprise_raw ||= {
      siren:                          info_etab[:siren],
      nic_siege_social:               info_entreprise[:nicSiegeUniteLegale],
      raison_sociale:                 info_entreprise[:denominationUniteLegale],
      sigle:                          info_entreprise[:sigleUniteLegale],
      etat_administratif:             info_entreprise[:etatAdministratifUniteLegale],
      diffusable_commercialement?:    yes_no_to_boolean(info_entreprise[:statutDiffusionUniteLegale]),
      date_creation:                  date_creation_entreprise,
      date_dernier_traitement:        date_dernier_traitement_entreprise,
      code_forme_juridique:           info_entreprise[:categorieJuridiqueUniteLegale],
      sexe:                           info_entreprise[:sexeUniteLegale],
      nom:                            info_entreprise[:nomUniteLegale],
      nom_usage:                      info_entreprise[:nomUsageUniteLegale],
      prenom_1:                       info_entreprise[:prenom1UniteLegale],
      prenom_2:                       info_entreprise[:prenom2UniteLegale],
      prenom_3:                       info_entreprise[:prenom3UniteLegale],
      prenom_4:                       info_entreprise[:prenom4UniteLegale],
      prenom_usuel:                   info_entreprise[:prenomUsuelUniteLegale],
      pseudonyme:                     info_entreprise[:pseudonymeUniteLegale],
      raison_sociale_usuelle_1:       info_entreprise[:denominationUsuelle1UniteLegale],
      raison_sociale_usuelle_2:       info_entreprise[:denominationUsuelle2UniteLegale],
      raison_sociale_usuelle_3:       info_entreprise[:denominationUsuelle3UniteLegale],
      code_naf:                       info_entreprise[:activitePrincipaleUniteLegale],
      nomenclature_naf:               info_entreprise[:nomenclatureActivitePrincipaleUniteLegale],
      id_rna:                         info_entreprise[:identifiantAssociationUniteLegale],
      economie_sociale_et_solidaire:  info_entreprise[:economieSocialeSolidaireUniteLegale],
      caractere_employeur:            info_entreprise[:caractereEmployeurUniteLegale],
      code_tranche_effectif_salarie:  info_entreprise[:trancheEffectifsUniteLegale],
      annee_tranche_effectif_salarie: info_entreprise[:anneeEffectifsUniteLegale],
      categorie_entreprise:           info_entreprise[:categorieEntreprise],
      annee_categorie_entreprise:     info_entreprise[:anneeCategorieEntreprise]
    }
  end

  def date_creation_entreprise
    nullable_date_to_timestamp info_entreprise[:dateCreationUniteLegale]
  end

  def date_dernier_traitement_entreprise
    nullable_date_to_timestamp info_entreprise[:dateDernierTraitementUniteLegale]
  end

  def nullable_date_to_timestamp(date)
    Time.zone.parse(date).to_i unless date.nil?
  end

  def yes_no_to_boolean(value)
    return unless ['N', 'O'].include?(value)
    value == 'O'
  end
end
