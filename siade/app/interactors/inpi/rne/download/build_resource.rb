class INPI::RNE::Download::BuildResource < BuildResource::Document
  def id
    context.params[:document_id]
  end
end
