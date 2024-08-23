class APIEntreprise::INPI::RNE::ActesDownloadSerializer::V3 < APIEntreprise::V3AndMore::DocumentSerializer
  attribute :document_url do
    url_for_proxied_file(data.document_url)
  end
end
