class QUALIBAT::CertificationsBatiment::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def file_type
    'pdf'
  end

  def filename
    'certificat_qualibat'
  end

  def source_file_content
    response.body
  end
end
