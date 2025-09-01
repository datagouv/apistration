class MEN::Scolarites::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    scolarite_not_found! if no_scolarite?

    return if http_ok?

    provider_timeout_error! if http_provider_timeout_error?

    provider_bad_gateway_error! if http_provider_bad_gateway_error?

    provider_internal_error! if http_internal_error?

    unknown_provider_response!
  end

  private

  def provider_timeout_error!
    fail_with_error!(ProviderTimeoutError.new('MEN'))
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Aucun élève n\'a pu être trouvé avec les critères de recherche fournis'))
  end

  def scolarite_not_found!
    fail_with_error!(
      ::NotFoundError.new(
        context.provider_name,
        'Aucune scolarité n\'a pu être trouvée pour cet élève',
        title: 'Scolarité non trouvée',
        subcode: '004',
        with_identifiant_message: false
      )
    )
  end

  def no_scolarite?
    http_ok? && !json_body['info-scolarite']['est-scolarise']
  end
end
