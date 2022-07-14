class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesSerializer::V3 < V3AndMore::BaseCollectionSerializer
  class ItemSerializer < V3AndMore::BaseSerializer
    attributes :numero_idcc,
      :titre,
      :titre_court,
      :active,
      :etat,
      :url,
      :synonymes,
      :date_publication
  end

  item_serializer ItemSerializer
end
