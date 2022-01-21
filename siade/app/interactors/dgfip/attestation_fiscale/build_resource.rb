class DGFIP::AttestationFiscale::BuildResource < BuildResource::Document
  def id
    context.params[:siren]
  end
end
