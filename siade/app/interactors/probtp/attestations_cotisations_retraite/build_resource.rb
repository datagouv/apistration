class PROBTP::AttestationsCotisationsRetraite::BuildResource < BuildResource::Document
  def id
    context.params[:siret]
  end
end
