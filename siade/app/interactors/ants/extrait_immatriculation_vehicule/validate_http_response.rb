class ANTS::ExtraitImmatriculationVehicule::ValidateHTTPResponse < ValidateResponse
  def call
    unknown_provider_response! if http_internal_error?

    resource_not_found! if not_found_in_response?
  end

  private

  def not_found_in_response?
    response.body.force_encoding('UTF-8').include?('Aucune réponse trouvée pour les critères en entrée')
  end
end
