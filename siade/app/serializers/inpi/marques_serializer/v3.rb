class INPI::MarquesSerializer::V3 < JSONAPI::BaseSerializer
  set_type :marque

  attributes :nom,
    :status,
    :depositaire,
    :clef
end
