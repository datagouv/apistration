class APIEntreprise::Infogreffe::MandatairesSociaux::PersonneMoraleSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :numero_identification,
    :type,
    :fonction,
    :raison_sociale,
    :code_greffe,
    :libelle_greffe
end
