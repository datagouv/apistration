class FranceTravail::Statut::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found? || http_code == 206
    unknown_provider_response! if !http_ok? || invalid_json? || inscription_category.blank?
  end

  private

  def inscription_category
    json_body['categorieInscription']
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Aucune situation France Travail n\'a pu être trouvée avec les critères de recherche fournis'))
  end
end
