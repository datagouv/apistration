class INPI::ActesDownload::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'actes_download_inpi'
  end
end
