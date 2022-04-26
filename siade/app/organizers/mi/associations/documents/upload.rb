class MI::Associations::Documents::Upload < UploadDocumentOrganizer
  organize Documents::StoreFromUrl

  def file_type
    'pdf'
  end

  def filename
    'document_association'
  end

  def source_file_content
    context.url
  end
end
