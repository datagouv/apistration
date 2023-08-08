class APIEntreprise::Qualifelec::CertificatsSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attributes :document_url,
      :numero,
      :rge,
      :date_debut,
      :date_fin,
      :qualification,
      :assurance_decennale,
      :assurance_civile
  end

  item_serializer ItemSerializer

  meta do |ctx|
    {
      count: ctx[:count]
    }
  end
end
