class APIEntreprise::INPI::ModeleSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attribute :type do
      'modele'
    end

    link :notice do
      data.notice_url
    end

    attributes :document_id,
      :numero_depot,
      :titre,
      :total_representations,
      :deposant,
      :date_depot,
      :date_publication,
      :classe,
      :reference
  end

  item_serializer ItemSerializer
end
