class CNETP::AttestationCotisationsCongesPayesChomageIntemperies::ValidateResponse < ValidateResponse
  declares_no_specific_errors!

  def call
    if http_not_found?
      resource_not_found!(:siret_or_siren)
    elsif http_unauthorized?
      provider_in_maintenance!
    elsif !http_ok?
      unknown_provider_response!
    end
  end
end
