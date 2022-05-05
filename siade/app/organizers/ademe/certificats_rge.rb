class ADEME::CertificatsRGE < RetrieverOrganizer
  before do
    context.params[:limit] = '1000' if context.params[:limit].blank?
  end

  organize ValidateSiret,
    ADEME::ValidateLimit,
    ADEME::CertificatsRGE::MakeRequest,
    ADEME::CertificatsRGE::ValidateResponse,
    ADEME::CertificatsRGE::BuildResourceCollection

  def provider_name
    'ADEME'
  end
end
