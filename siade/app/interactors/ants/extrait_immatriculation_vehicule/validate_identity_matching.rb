class ANTS::ExtraitImmatriculationVehicule::ValidateIdentityMatching < ValidateResponse
  def call
    resource_not_found! unless match_in_response

    return if match_in_response

    unknown_provider_response!
  end

  private

  def match_in_response
    @match_in_response ||= ANTSRegistrationMatcherService.new(context:).match?
  end
end
