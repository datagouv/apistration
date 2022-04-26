class MI::DocumentAssociationSerializer::V3 < V3AndMore::BaseSerializer
  attributes :timestamp,
    :type,
    :url,
    :expires_in
end
