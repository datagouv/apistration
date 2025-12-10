class INSEE::UniteLegale::BuildResource < INSEE::BuildResource
  protected

  def resource_attributes
    {
      siren:,
      rna:,
      siret_siege_social:,

      type: type_of_person,

      personne_morale_attributs: {
        raison_sociale: unite_legale['denominationUniteLegale'],
        sigle: unite_legale['sigleUniteLegale']
      },

      personne_physique_attributs: {
        pseudonyme: unite_legale['pseudonymeUniteLegale'],
        prenom_usuel: unite_legale['prenomUsuelUniteLegale'],
        prenom_1: unite_legale['prenom1UniteLegale'],
        prenom_2: unite_legale['prenom2UniteLegale'],
        prenom_3: unite_legale['prenom3UniteLegale'],
        prenom_4: unite_legale['prenom4UniteLegale'],
        nom_usage: unite_legale['nomUsageUniteLegale'],
        nom_naissance: unite_legale['nomUniteLegale'],
        sexe: unite_legale['sexeUniteLegale']
      },

      categorie_entreprise: unite_legale['categorieEntreprise'],
      status_diffusion: STATUT_DIFFUSION[unite_legale['statutDiffusionUniteLegale']],
      diffusable_commercialement: diffusable_commercialement(unite_legale['statutDiffusionUniteLegale']),

      forme_juridique: referential(
        'categorie_juridique',
        code: categorie_juridique
      ),
      activite_principale: activite_principale_naf2025.to_h,
      activite_principale_naf_rev2: activite_principale_naf_rev2.to_h,
      tranche_effectif_salarie: referential(
        'tranche_effectif_salarie',
        code: unite_legale['trancheEffectifsUniteLegale'],
        date_reference: unite_legale['anneeEffectifsUniteLegale']
      ),

      economie_sociale_et_solidaire: yes_no_to_boolean(unite_legale['economieSocialeSolidaireUniteLegale']),

      date_creation:,

      etat_administratif:,
      date_cessation:,

      date_derniere_mise_a_jour: date_to_timestamp(unite_legale['dateDernierTraitementUniteLegale']),

      redirect_from_siren: context.redirect_from_siren
    }
  end

  private

  def unite_legale
    @unite_legale ||= context.unite_legale || build_unite_legale_info_with_latest_info_from_periodes
  end

  def build_unite_legale_info_with_latest_info_from_periodes
    json_body['uniteLegale'].merge(latest_info_on_unite_legale)
  end

  def latest_info_on_unite_legale
    @latest_info_on_unite_legale ||= (json_body['uniteLegale']['periodesUniteLegale'] || []).find do |periode_unite_legale|
      periode_unite_legale['dateFin'].nil?
    end || {}
  end

  def date_cessation
    return if entreprise_active?
    return if periode_with_cessation_status.blank?

    date_to_timestamp(periode_with_cessation_status['dateDebut'])
  end

  def periode_with_cessation_status
    (unite_legale['periodesUniteLegale'] || []).find do |periode_unite_legale|
      periode_unite_legale['changementEtatAdministratifUniteLegale']
    end
  end

  def entreprise_active?
    etat_administratif == 'A'
  end

  def etat_administratif
    unite_legale['etatAdministratifUniteLegale']
  end

  def type_of_person
    if categorie_juridique == '1000'
      :personne_physique
    elsif categorie_juridique.present?
      :personne_morale
    end
  end

  def categorie_juridique
    unite_legale['categorieJuridiqueUniteLegale']
  end

  def rna
    unite_legale['identifiantAssociationUniteLegale']
  end

  def siren
    unite_legale['siren'] || etablissement['siret'].first(9)
  end

  def date_creation
    return if unite_legale['dateCreationUniteLegale'] == '1900-01-01'

    date_to_timestamp(unite_legale['dateCreationUniteLegale'])
  end

  def siret_siege_social
    "#{siren}#{unite_legale['nicSiegeUniteLegale']}"
  end

  def etablissement
    json_body['etablissement'] || json_body['etablissements'][0]
  end

  def activite_principale_naf2025
    @activite_principale_naf2025 ||= Referentials::ActivitePrincipale.new(
      code: unite_legale['activitePrincipaleNAF25UniteLegale'],
      nomenclature: 'NAF2025'
    )
  end

  def activite_principale_naf_rev2
    @activite_principale_naf_rev2 ||= Referentials::ActivitePrincipale.new(
      code: unite_legale['activitePrincipaleUniteLegale'],
      nomenclature: 'NAFRev2'
    )
  end
end
