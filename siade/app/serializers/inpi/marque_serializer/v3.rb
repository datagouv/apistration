class INPI::MarqueSerializer::V3 < V3AndMore::BaseSerializer
  set_type :marque

  link :notice, :notice_url

  attributes :nom,
    :status,
    :depositaire,
    :clef
end
