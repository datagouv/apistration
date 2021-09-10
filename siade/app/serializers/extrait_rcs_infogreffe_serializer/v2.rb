class ExtraitRCSInfogreffeSerializer::V2 < ActiveModel::Serializer
  attributes :siren,
    :date_immatriculation,
    :date_immatriculation_timestamp,
    :date_extrait

  attribute :liste_observations, key: :observations
end
