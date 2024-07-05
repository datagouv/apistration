class INPI::RNE::BilansDownload::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'bilans_download_inpi'
  end
end
