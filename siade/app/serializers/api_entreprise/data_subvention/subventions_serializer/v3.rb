class APIEntreprise::DataSubvention::SubventionsSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attributes :demande_subvention,
      :paiements
  end

  item_serializer ItemSerializer

  meta do
    {}
  end
end
