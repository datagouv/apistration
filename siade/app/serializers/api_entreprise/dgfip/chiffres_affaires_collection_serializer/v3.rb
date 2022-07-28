class APIEntreprise::DGFIP::ChiffresAffairesCollectionSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  item_serializer APIEntreprise::DGFIP::ChiffresAffairesSerializer::V3

  meta do |ctx|
    {
      count: ctx[:count]
    }
  end
end
