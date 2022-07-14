class INPI::BrevetSerializer::V3 < V3AndMore::BaseCollectionSerializer
  class ItemSerializer < V3AndMore::BaseSerializer
    attributes :numero_publication,
      :titre,
      :date_publication,
      :date_depot,
      :code_zone,
      :numero_brevet,
      :categorie_publication
  end

  item_serializer ItemSerializer
end
