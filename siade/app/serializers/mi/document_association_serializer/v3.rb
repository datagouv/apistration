class MI::DocumentAssociationSerializer::V3 < V3AndMore::BaseCollectionSerializer
  class ItemSerializer < V3AndMore::BaseSerializer
    attributes :timestamp,
      :type,
      :url,
      :expires_in,
      :errors
  end

  item_serializer ItemSerializer

  meta do |ctx|
    {
      nombre_documents: ctx[:nombre_documents],
      nombre_documents_deficients: ctx[:nombre_documents_deficients]
    }
  end
end
