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

  def resource_not_found!
    return fail_with_error!(build_qfv2_error(::NotFoundError, 'CNAF', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.", 'Dossier allocataire absent CNAF')) if regime == 'CNAF'
    return fail_with_error!(build_qfv2_error(::NotFoundError, 'MSA', "Le dossier allocataire n'a pas été trouvé auprès de la MSA.", 'Dossier allocataire absent MSA')) if regime == 'MSA'

    fail_with_error!(UnprocessableEntityError.new(:sngi))
  end

  def regime
    return REGIME_CODE_LABEL[response.header['X-APISECU-FD']] if response.header['X-APISECU-FD'].present?

    'SNGI'
  end

  private

  def build_qfv2_error(error_klass, provider, message = nil, title = nil)
    error_klass.new(provider, message, title:, with_identifiant_message: false)
  end
end
