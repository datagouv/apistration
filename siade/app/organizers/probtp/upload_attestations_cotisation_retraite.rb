class PROBTP::UploadAttestationsCotisationRetraite < UploadDocumentOrganizer
  organize Documents::StoreFromBase64

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
