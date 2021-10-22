class INSEE::EtablissementSerializer::V3 < JSONAPI::BaseSerializer
  set_type :etablissement

  attributes :siege_social,
    :etat_administratif,
    :activite_principale,
    :tranche_effectif_salarie,
    :diffusable_commercialement,
    :date_creation

  link :entreprise do |object|
    "https://entreprises.api.gouv.fr/api/v3/insee/entreprises/#{object.siren}"
  end

  meta do |object|
    {
      date_derniere_mise_a_jour: object.date_derniere_mise_a_jour
    }
  end
end
