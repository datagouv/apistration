class APIEntreprise::Infogreffe::MandatairesSociaux::PersonnePhysiqueSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :fonction,
    :nom,
    :type,
    :prenom,
    :date_naissance,
    :date_naissance_timestamp,
    :lieu_naissance,
    :pays_naissance,
    :code_pays_naissance,
    :nationalite,
    :code_nationalite
end
