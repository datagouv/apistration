class APIEntreprise::INPI::RNE::ExtraitDownloadSerializer::V3 < APIEntreprise::V3AndMore::DocumentSerializer
  attribute :document_url do
    url_for_proxied_file(data.document_url)
  end
end
