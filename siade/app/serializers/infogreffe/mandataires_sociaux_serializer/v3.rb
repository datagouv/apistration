class Infogreffe::MandatairesSociauxSerializer::V3 < JSONAPI::BaseSerializer
  set_type :mandataires_sociaux

  attributes :pp,
    :pm
end
