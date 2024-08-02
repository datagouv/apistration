class CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'certificat_cibtp'
  end

  def expires_in
    10.minutes.to_i
  end
end
