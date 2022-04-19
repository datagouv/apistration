class Infogreffe::PersonneMoraleSerializer::V3 < V3AndMore::BaseSerializer
  attributes :numero_identification,
    :type,
    :fonction,
    :raison_sociale,
    :code_greffe,
    :libelle_greffe
end
