class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesSerializer::V3 < V3AndMore::BaseCollectionSerializer
  class ItemSerializer < V3AndMore::BaseSerializer
    attribute :type do
      'convention_collective'
    end

    attributes :numero_idcc,
      :titre,
      :titre_court,
      :active,
      :etat,
      :url,
      :synonymes,
      :date_publication

    meta do |object|
      {
        internal_id: object.id
      }
    end
  end

  item_serializer ItemSerializer
end
