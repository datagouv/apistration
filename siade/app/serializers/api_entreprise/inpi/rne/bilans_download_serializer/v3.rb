class APIEntreprise::INPI::RNE::BilansDownloadSerializer::V3 < APIEntreprise::V3AndMore::DocumentSerializer
  attribute :document_url do |object|
    url_for_proxied_file(object.document_url)
  end
end
