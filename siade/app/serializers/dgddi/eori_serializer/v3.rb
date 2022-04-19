class DGDDI::EORISerializer::V3 < V3AndMore::BaseSerializer
  set_type :entreprise

  attributes :id,
    :actif,
    :code_pays,
    :code_postal,
    :libelle,
    :pays,
    :rue,
    :ville
end
