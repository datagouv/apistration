class QUALIBAT::CertificationsBatiment::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromUrl

  def file_type
    'pdf'
  end

  def filename
    'certificat_qualibat'
  end

  def source_file_content
    json_body['URL']
  end
end
