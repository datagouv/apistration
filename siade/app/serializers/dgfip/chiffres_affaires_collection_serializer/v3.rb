class DGFIP::ChiffresAffairesCollectionSerializer::V3 < V3AndMore::BaseCollectionSerializer
  item_serializer DGFIP::ChiffresAffairesSerializer::V3

  meta do |ctx|
    {
      count: ctx[:count]
    }
  end
end
