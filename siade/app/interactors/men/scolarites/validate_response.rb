class MEN::Scolarites::ValidateResponse < ValidateResponse
  raises MENError, kind: :scolarite_not_found
  raises MENError, kind: :eleve_hors_perimetre

  ELEVE_HORS_PERIMETRE_TITLE = "L'élève est hors périmètre".freeze

  def call
    validate_eleve_found!

    return if http_ok?

    provider_timeout_error! if http_provider_timeout_error?

    provider_bad_gateway_error! if http_provider_bad_gateway_error?

    provider_internal_error! if http_internal_error?

    unknown_provider_response!
  end

  private

  def validate_eleve_found!
    resource_not_found! if http_not_found?
    scolarite_not_found! if no_scolarite?
    eleve_hors_perimetre! if eleve_hors_perimetre?
  end

  def provider_timeout_error!
    fail_with_error!(ProviderTimeoutError.new('MEN'))
  end

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, 'Aucun élève n\'a pu être trouvé avec les critères de recherche fournis'))
  end

  def scolarite_not_found!
    fail_with_error!(MENError.new(:scolarite_not_found))
  end

  def eleve_hors_perimetre!
    fail_with_error!(MENError.new(:eleve_hors_perimetre))
  end

  def eleve_hors_perimetre?
    http_forbidden? && body.present? && valid_json? && Hash.try_convert(json_body)&.fetch('title', nil) == ELEVE_HORS_PERIMETRE_TITLE
  end

  def no_scolarite?
    http_ok? && !json_body['info-scolarite']['est-scolarise']
  end
end
