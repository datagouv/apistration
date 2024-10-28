class CNAV::QuotientFamilialV2::ValidateResponse < CNAV::ValidateResponse
  REGIME_CODE_MSA = '00171001'.freeze
  REGIME_CODE_CNAF = '00810011'.freeze

  REGIME_CODE_LABEL = {
    REGIME_CODE_MSA => 'MSA',
    REGIME_CODE_CNAF => 'CNAF'
  }.freeze

  def call
    resource_not_found! if http_not_found?
    handle_http_too_many_requests! if http_too_many_requests?
    unknown_provider_response! if !http_ok? || invalid_json?
  end

  protected

  def not_found_message
    return "Le dossier allocataire n'a pas été trouvé auprès de la CNAF." if regime == 'CNAF'
    return "Le dossier allocataire n'a pas été trouvé auprès de la MSA." if regime == 'MSA'
    return "L'allocataire que vous cherchez n'a pas été reconnu." if regime == 'SNGI'

    'Dossier allocataire inexistant. Le document ne peut être édité.'
  end

  def regime
    return REGIME_CODE_LABEL[response.header['X-APISECU-FD']] if response.header['X-APISECU-FD']

    'SNGI'
  end
end
