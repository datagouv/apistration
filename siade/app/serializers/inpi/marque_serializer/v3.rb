class INPI::MarqueSerializer::V3 < V3AndMore::BaseCollectionSerializer
  class ItemSerializer < V3AndMore::BaseSerializer
    link :notice, &:notice_url

    attributes :numero_application,
      :nom,
      :status,
      :depositaire,
      :clef
  end

  item_serializer ItemSerializer
end
