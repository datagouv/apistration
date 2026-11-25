class MI::SIAF::FondationsDownload::BuildResource < BuildResource::Document
  def id
    context.params[:file_id]
  end
end
