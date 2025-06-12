class MESRI::StudentStatus::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?

    return if http_ok? && valid_json? && data_present?

    unknown_provider_response!
  end

  private

  def data_present?
    json_body['nomFamille'].present?
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Aucun étudiant n\'a pu être trouvé avec les critères de recherche fournis'))
  end
end
