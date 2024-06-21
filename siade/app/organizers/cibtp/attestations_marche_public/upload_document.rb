class CIBTP::AttestationsMarchePublic::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'attestations_marche_public_cibtp'
  end
end
