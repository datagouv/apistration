class APIEntreprise::MI::DocumentAssociationSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attributes :timestamp,
      :type,
      :expires_in,
      :errors

    attribute :url do |object|
      url_for_proxied_file(object.url)
    end
  end

  item_serializer ItemSerializer

  meta do |ctx|
    {
      nombre_documents: ctx[:nombre_documents],
      nombre_documents_deficients: ctx[:nombre_documents_deficients]
    }
  end
end
