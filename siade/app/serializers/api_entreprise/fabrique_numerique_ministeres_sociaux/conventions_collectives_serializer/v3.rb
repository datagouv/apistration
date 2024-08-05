class APIEntreprise::FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
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

    meta do |ctx|
      {
        internal_id: ctx.id
      }
    end
  end

  item_serializer ItemSerializer
end
