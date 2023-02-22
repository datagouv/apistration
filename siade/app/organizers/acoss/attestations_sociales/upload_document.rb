class ACOSS::AttestationsSociales::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBase64

  def source_file_content
    context.response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'attestation-vigilance-urssaf'
  end
end
