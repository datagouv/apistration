class FNTP::CarteProfessionnelleTravauxPublics::ValidateResponse < ValidateResponse
  def call
    if http_not_found?
      resource_not_found!
    elsif !http_ok?
      unknown_provider_response!
    end
  end
end
