class APIEntreprise::ExtraitRCSInfogreffeSerializer::V2 < APIEntreprise::V2BaseSerializer
  attributes :siren,
    :date_immatriculation,
    :date_immatriculation_timestamp,
    :date_extrait

  attribute :liste_observations, key: :observations
end
