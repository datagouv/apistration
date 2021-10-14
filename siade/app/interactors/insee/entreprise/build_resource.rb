class INSEE::Entreprise::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      id: siren,
      siret_siege_social: "#{unite_legale_json['siren']}#{latest_info_on_unite_legale['nicSiegeUniteLegale']}",

      type: type_of_person,

      personne_morale_attributs: {
        raison_sociale: latest_info_on_unite_legale['denominationUniteLegale']
      },

      personne_physique_attributs: {
        pseudonyme: unite_legale_json['pseudonymeUniteLegale'],
        prenom_usuel: unite_legale_json['prenomUsuelUniteLegale'],
        prenom_1: unite_legale_json['prenom1UniteLegale'],
        prenom_2: unite_legale_json['prenom2UniteLegale'],
        prenom_3: unite_legale_json['prenom3UniteLegale'],
        prenom_4: unite_legale_json['prenom4UniteLegale'],
        nom_usage: latest_info_on_unite_legale['nomUsageUniteLegale'],
        nom_naissance: latest_info_on_unite_legale['nomUniteLegale'],
        sexe: unite_legale_json['sexeUniteLegale']
      },

      categorie_entreprise: unite_legale_json['categorieEntreprise'],
      numero_tva_intracommunautaire: compute_numero_tva_intracommunautaire,
      diffusable_commercialement: yes_no_to_boolean(unite_legale_json['statutDiffusionUniteLegale']),

      forme_juridique: referential(
        'categorie_juridique',
        code: categorie_juridique
      ),
      activite_principale: referential(
        'activite_principale',
        code: latest_info_on_unite_legale['activitePrincipaleUniteLegale'],
        nomenclature: latest_info_on_unite_legale['nomenclatureActivitePrincipaleUniteLegale']
      ),
      tranche_effectif_salarie: referential(
        'tranche_effectif_salarie',
        code: unite_legale_json['trancheEffectifsUniteLegale'],
        date_reference: unite_legale_json['anneeEffectifsUniteLegale']
      ),

      date_creation: date_to_timestamp(unite_legale_json['dateCreationUniteLegale']),

      etat_administratif: etat_administratif,
      date_cessation: date_cessation,

      date_derniere_mise_a_jour: date_to_timestamp(unite_legale_json['dateDernierTraitementUniteLegale'])
    }
  end

  private

  def unite_legale_json
    @unite_legale_json ||= json_body['uniteLegale']
  end

  def latest_info_on_unite_legale
    unite_legale_json['periodesUniteLegale'].find do |periode_unite_legale|
      periode_unite_legale['dateFin'].nil?
    end
  end

  def compute_numero_tva_intracommunautaire
    cle_tva = ((12 + (3 * (siren.to_i % 97))) % 97).to_s
    padded_cle_tva = cle_tva.rjust(2, '0')
    "FR#{padded_cle_tva}#{siren}"
  end

  def date_cessation
    return if entreprise_active?

    date_to_timestamp(periode_with_cessation_status['dateDebut'])
  end

  def periode_with_cessation_status
    unite_legale_json['periodesUniteLegale'].find do |periode_unite_legale|
      periode_unite_legale['changementEtatAdministratifUniteLegale']
    end
  end

  def entreprise_active?
    etat_administratif == 'A'
  end

  def etat_administratif
    latest_info_on_unite_legale['etatAdministratifUniteLegale']
  end

  def type_of_person
    if categorie_juridique == '1000'
      :personne_physique
    else
      :personne_morale
    end
  end

  def categorie_juridique
    latest_info_on_unite_legale['categorieJuridiqueUniteLegale']
  end

  def siren
    unite_legale_json['siren']
  end

  def referential(name, params)
    SIADE::V2::Referentials.const_get(name.classify).new(params).as_json
  end

  def yes_no_to_boolean(value)
    value && value == 'O'
  end

  def date_to_timestamp(value)
    return if value.nil?

    Date.parse(value).to_time.to_i
  end
end
