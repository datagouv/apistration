class APIEntreprise::INSEE::EtablissementSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siege_social,
    :etat_administratif,
    :date_fermeture,
    :activite_principale,
    :tranche_effectif_salarie,
    :diffusable_commercialement,
    :date_creation

  attribute :unite_legale do |object|
    object.unite_legale.to_h.except(
      :id
    )
  end

  attribute :adresse do |object|
    object.adresse.to_h.except(
      :id,
      :siren,
      :date_derniere_mise_a_jour
    )
  end

  link :entreprise do |object|
    "https://entreprises.api.gouv.fr/api/v3/insee/entreprises/#{object.siren}"
  end

  meta do |object|
    {
      date_derniere_mise_a_jour: object.date_derniere_mise_a_jour
    }
  end
end
