class APIEntreprise::QUALIBAT::CertificationBatimentSerializer::V4 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :document_url,
    :document_url_expires_in,
    :date_emission,
    :date_fin_validite,
    :entity

  meta do |ctx|
    {
      extractor_error: ctx.try(:extractor_error)
    }
  end
end
