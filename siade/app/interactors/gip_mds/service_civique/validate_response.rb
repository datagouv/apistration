class GIPMDS::ServiceCivique::ValidateResponse < ValidateResponse
  def call
    monitor_multiple_contracts if multiple_contracts?

    return if successful_response?
    return if not_found_contrat?

    resource_not_found! if not_found_individu?
    too_many_individus! if too_many_individus?

    unknown_provider_response!
  end

  private

  def successful_response?
    http_code == 200 && valid_payload?
  end

  def valid_payload?
    json_body.key?('individu')
  end

  def multiple_contracts?
    return false unless successful_response?

    all_contracts.size > 1
  end

  def all_contracts
    @all_contracts ||= extract_all_contracts
  end

  def extract_all_contracts
    entreprises = json_body.dig('individu', 'entreprise') || []
    entreprises.flat_map { |e| extract_contracts_from_entreprise(e) }
  end

  def extract_contracts_from_entreprise(entreprise)
    etablissements = entreprise['etablissement'] || []
    etablissements.flat_map { |e| e['contrat'] || [] }
  end

  def monitor_multiple_contracts
    MonitoringService.instance.track(
      'warning',
      'GIPMDS::ServiceCivique: individual has multiple service civique contracts'
    )
  end

  def not_found_individu?
    http_code == 404 && error_code == 'NOT_FOUND_INDIVIDU'
  end

  def not_found_contrat?
    http_code == 404 && error_code == 'NOT_FOUND_CONTRAT'
  end

  def too_many_individus?
    http_code == 413 && error_code == 'TOO_MANY_INDIVIDU'
  end

  def too_many_individus!
    fail_with_error!(::UnprocessableEntityError.new(:gip_mds_too_many_individus))
  end

  def error_code
    json_body.dig('erreurs', 0, 'code')
  end
end
