class CNETP::AttestationCotisationsCongesPayesChomageIntemperies::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'certificat_cnetp'
  end
end
