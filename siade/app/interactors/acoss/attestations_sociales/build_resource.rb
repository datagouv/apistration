class ACOSS::AttestationsSociales::BuildResource < BuildResource::Document
  def id
    context.params[:siren]
  end
end
