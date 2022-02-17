class Infogreffe::ExtraitsRCSSerializer::V3 < JSONAPI::BaseSerializer
  set_type :extraits_rcs

  attributes :date_extrait,
    :date_immatriculation,
    :observations
end
