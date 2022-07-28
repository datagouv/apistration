class APIEntreprise::ADEME::CertificatRGESerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attributes :url,
      :nom_certificat,
      :domaine,
      :meta_domaine,
      :qualification,
      :organisme,
      :date_attribution,
      :date_expiration,
      :meta
  end

  item_serializer ItemSerializer
end
