class INSEE::UniteLegale::BuildResource < INSEE::BuildResource
  protected

  def resource_attributes
    {
      id: siren,
      siret_siege_social:,

      type: type_of_person,

      personne_morale_attributs: {
        raison_sociale: unite_legale['denominationUniteLegale']
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
      numero_tva_intracommunautaire: compute_numero_tva_intracommunautaire,
      diffusable_commercialement: yes_no_to_boolean(unite_legale['statutDiffusionUniteLegale']),

      forme_juridique: referential(
        'categorie_juridique',
        code: categorie_juridique
      ),
      activite_principale: referential(
        'activite_principale',
        code: unite_legale['activitePrincipaleUniteLegale'],
        nomenclature: unite_legale['nomenclatureActivitePrincipaleUniteLegale']
      ),
      tranche_effectif_salarie: referential(
        'tranche_effectif_salarie',
        code: unite_legale['trancheEffectifsUniteLegale'],
        date_reference: unite_legale['anneeEffectifsUniteLegale']
      ),

      date_creation: date_to_timestamp(unite_legale['dateCreationUniteLegale']),

      etat_administratif:,
      date_cessation:,

      date_derniere_mise_a_jour: date_to_timestamp(unite_legale['dateDernierTraitementUniteLegale'])
    }
  end

  private

  def unite_legale
    @unite_legale ||= (context.unite_legale || build_unite_legale_info_with_latest_info_from_periodes)
  end

  def build_unite_legale_info_with_latest_info_from_periodes
    json_body['uniteLegale'].merge(latest_info_on_unite_legale)
  end

  def latest_info_on_unite_legale
    @latest_info_on_unite_legale ||= (json_body['uniteLegale']['periodesUniteLegale'] || []).find do |periode_unite_legale|
      periode_unite_legale['dateFin'].nil?
    end || {}
  end

  def compute_numero_tva_intracommunautaire
    TVAIntracommunautaire.new(siren).perform
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

  def siren
    unite_legale['siren'] || etablissement['siret'].first(9)
  end

  def siret_siege_social
    "#{siren}#{unite_legale['nicSiegeUniteLegale']}"
  end

  def etablissement
    json_body['etablissement'] || json_body['etablissements'][0]
  end
end
