class CNETP::AttestationCotisationsCongesPayesChomageIntemperies::BuildResource < BuildResource::Document
  def id
    context.params[:siren]
  end
end
