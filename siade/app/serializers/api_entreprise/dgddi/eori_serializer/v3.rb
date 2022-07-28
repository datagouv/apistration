class APIEntreprise::DGDDI::EORISerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :id,
    :actif,
    :code_pays,
    :code_postal,
    :libelle,
    :pays,
    :rue,
    :ville
end
