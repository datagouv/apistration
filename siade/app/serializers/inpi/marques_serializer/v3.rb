class INPI::MarquesSerializer::V3 < JSONAPI::BaseSerializer
  set_type :marque

  link :notice

  attributes :nom,
    :status,
    :depositaire,
    :clef
end
