class MI::SIAF::FondationsDownload::UploadDocument < UploadDocumentOrganizer
  organize Documents::Upload

  def source_file_content
    response.body
  end

  def file_type
    Marcel::Magic.new(context.params[:mime_type].to_s.downcase).extensions.first || 'bin'
  end

  def filename
    'piece_jointe_fondation_siaf'
  end
end
