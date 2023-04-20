class DGFIP::SituationIR::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    resource_not_found! if [404, 410].include?(http_code)

    unknown_provider_response!
  end
end
