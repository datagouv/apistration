class PROBTP::AttestationsCotisationsRetraite::PrepareDocumentStorage < Documents::PrepareStorage
  def source_file_content
    json_body['data']
  end

  def file_type
    'pdf'
  end

  def filename
    'attestation_cotisation_retraite_probtp'
  end
end
