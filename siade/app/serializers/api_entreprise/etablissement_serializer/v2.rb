class APIEntreprise::EtablissementSerializer::V2 < APIEntreprise::V2BaseSerializer
  attribute :siege_social?, key: :siege_social
  attributes :siret, :naf, :libelle_naf, :date_mise_a_jour,
    :tranche_effectif_salarie_etablissement,
    :date_creation_etablissement,
    :region_implantation, :commune_implantation, :pays_implantation,
    :diffusable_commercialement, :enseigne

  attribute :adresse
  attribute :etat_administratif

  # rubocop:disable Metrics/MethodLength
  def adresse
    {
      l1: object.l1,
      l2: object.l2,
      l3: object.l3,
      l4: object.l4,
      l5: object.l5,
      l6: object.l6,
      l7: object.l7,
      numero_voie: object.numero_voie,
      type_voie: object.type_voie,
      nom_voie: object.nom_voie,
      complement_adresse: object.complement_adresse,
      code_postal: object.code_postal,
      localite: object.localite,
      code_insee_localite: object.code_insee_localite,
      cedex: object.cedex
    }
  end
  # rubocop:enable Metrics/MethodLength

  def etat_administratif
    {
      value: @object.etat_administratif,
      date_fermeture: @object.date_fermeture
    }
  end
end
