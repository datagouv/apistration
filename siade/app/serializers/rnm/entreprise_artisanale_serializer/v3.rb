class RNM::EntrepriseArtisanaleSerializer::V3 < JSONAPISerializer
  set_type :entreprise

  attributes :siren,
             :modalite_exercice,
             :non_sedentaire

  belongs_to :adresse, serializer: AdresseSerializer, links: {
    related: ->(object) {
      "https://entreprises.api.gouv.fr/api/v3/insee/adresse/#{object.id}"
    }
  }
end
