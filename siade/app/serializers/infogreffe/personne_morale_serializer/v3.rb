class Infogreffe::PersonneMoraleSerializer::V3 < V3AndMore::BaseSerializer
  set_type :personne_morale

  attributes :fonction,
    :raison_sociale,
    :code_greffe,
    :libelle_greffe
end
