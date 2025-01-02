class FranceTravail::Statut::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found? || http_code == 206
    handle_timeout! if france_travail_timeout?
    unknown_provider_response! if !http_ok? || invalid_json? || inscription_category.blank?
  end

  private

  def france_travail_timeout?
    http_code == 500 && json_body['messageLog']&.include?('java.util.concurrent.TimeoutException')
  end

  def handle_timeout!
    fail_with_error!(ProviderTimeoutError.new('France Travail'))
  end

  def inscription_category
    json_body['categorieInscription']
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Aucune situation France Travail n\'a pu être trouvée avec les critères de recherche fournis'))
  end
end
