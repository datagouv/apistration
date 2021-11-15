class Douanes::EORISerializer::V3 < JSONAPI::BaseSerializer
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
