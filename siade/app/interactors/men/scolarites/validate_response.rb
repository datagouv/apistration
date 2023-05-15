class MEN::Scolarites::ValidateResponse < ValidateResponse
  def call
    provider_timeout_error! if http_provider_timeout_error?

    provider_bad_gateway_error! if http_provider_bad_gateway_error?

    provider_internal_error! if http_internal_error?

    resource_not_found! if http_not_found?

    return if http_ok?

    unknown_provider_response!
  end

  private

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Aucun étudiant n\'a pu être trouvé avec les critères de recherche fournis'))
  end
end
