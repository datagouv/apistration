class APIEntreprise::QUALIBAT::CertificationBatimentSerializer::V3 < APIEntreprise::V3AndMore::DocumentSerializer
  attributes :document_url

  attribute :expires_in, &:document_url_expires_in
end
