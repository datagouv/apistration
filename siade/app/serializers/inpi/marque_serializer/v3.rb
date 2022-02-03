class INPI::MarqueSerializer::V3 < JSONAPI::BaseSerializer
  set_type :marque

  link :notice, :notice_url

  attributes :nom,
    :status,
    :depositaire,
    :clef
end
