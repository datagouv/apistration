class ADEME::CertificatsRGE::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?

    resource_not_found!(:siret) if no_results?
  end

  private

  def no_results?
    json_body['results'].empty?
  end
end
