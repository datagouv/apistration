class MESRI::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unprocessable_entity_error! if http_bad_request?

    return if http_ok? && !invalid_json? && data_present?

    unknown_provider_response!
  end

  private

  def data_present?
    json_body['nomFamille'].present?
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Aucun étudiant n\'a pu être trouvé avec les critères de recherche fournis'))
  end

  def unprocessable_entity_error!
    fail_with_error!(::UnprocessableEntityError.new(:ine))
  end

  def http_bad_request?
    http_code == 400
  end
end
