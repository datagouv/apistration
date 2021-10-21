class RNM::EntrepriseArtisanaleSerializer::V3 < JSONAPI::BaseSerializer
  set_type :entreprise

  attributes :modalite_exercice,
    :non_sedentaire
end
