class INPI::MarqueSerializer::V3 < V3AndMore::BaseSerializer
  link :notice, &:notice_url

  attributes :numero_application,
    :nom,
    :status,
    :depositaire,
    :clef
end
