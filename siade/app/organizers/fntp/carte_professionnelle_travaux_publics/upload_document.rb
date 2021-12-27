class FNTP::CarteProfessionnelleTravauxPublics::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'carte_professionnelle_fntp'
  end
end
