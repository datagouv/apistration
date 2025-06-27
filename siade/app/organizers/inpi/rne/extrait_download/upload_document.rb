class INPI::RNE::ExtraitDownload::UploadDocument < UploadDocumentOrganizer
  organize Documents::StoreFromBinary

  def source_file_content
    response.body
  end

  def file_type
    'pdf'
  end

  def filename
    'extrait_rne_download_inpi'
  end
end
