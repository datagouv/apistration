class Infogreffe::MandatairesSociauxSerializer::V3 < JSONAPI::BaseSerializer
  set_type :mandataires_sociaux

  attributes :id,
    :nom,
    :prenom,
    :fonction,
    :date_naissance,
    :date_naissance_timestamp,
    :lieu_naissance,
    :pays_naissance,
    :code_pays_naissance,
    :nationalite,
    :code_nationalite,
    :raison_sociale,
    :code_greffe,
    :libelle_greffe,
    :identifiant
end
