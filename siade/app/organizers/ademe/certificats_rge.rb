class ADEME::CertificatsRGE < RetrieverOrganizer
  before do
    context.params[:limit] = 1000 if context.params[:limit].blank?
    context.params[:limit] = context.params[:limit].to_i
  end

  organize ValidateSiret,
    ADEME::ValidateLimit,
    ADEME::CertificatsRGE::MakeRequest,
    ADEME::CertificatsRGE::ValidateResponse,
    ADEME::CertificatsRGE::BuildResourceCollection

  def provider_name
    'ADEME'
  end

  def limit
    context.params[:limit]
  end
end
