class APIEntreprise::INPI::BrevetSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attribute :type do
      'brevet'
    end

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
