class ANTS::ExtraitImmatriculationVehicule::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! if http_internal_error?

    resource_not_found! if not_found_in_response? || !match_in_response

    return if match_in_response

    unknown_provider_response!
  end

  private

  def match_in_response
    @match_in_response ||= ANTSRegistrationMatcherService.new(context:).match?
  end

  def not_found_in_response?
    response.body.include?('Aucune réponse trouvée pour les critères en entrée')
  end
end
