class INPI::MarquesSerializer::V3 < JSONAPI::BaseSerializer
  set_type :marque

  attributes :marque,
    :marque_status,
    :depositaire,
    :clef
end
