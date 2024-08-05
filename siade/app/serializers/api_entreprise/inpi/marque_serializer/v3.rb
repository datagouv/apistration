class APIEntreprise::INPI::MarqueSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    link :notice do
      data.notice_url
    end

    attribute :type do
      'marque'
    end

    attributes :numero_application,
      :nom,
      :status,
      :depositaire,
      :clef
  end

  item_serializer ItemSerializer
end
