class Infogreffe::MandataireSocialSerializer::V3 < JSONAPI::BaseSerializer
  set_type :mandataire_social

  attributes :nom,
    :prenom,
    :fonction,
    :date_naissance,
    :date_naissance_timestamp,
    :raison_sociale,
    :identifiant,
    :type
end
