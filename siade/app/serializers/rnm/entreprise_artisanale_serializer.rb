class RNM::EntrepriseArtisanaleSerializer < JSONAPISerializer
  set_type :entreprise

  attributes :siren,
             :modalite_exercice,
             :non_sedentaire
end
