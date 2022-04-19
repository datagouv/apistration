class RNM::EntrepriseArtisanaleSerializer::V3 < V3AndMore::BaseSerializer
  set_type :entreprise

  attributes :modalite_exercice,
    :non_sedentaire
end
