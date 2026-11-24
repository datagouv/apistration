class CNAV::FoyerRSA::ValidateResponse < CNAV::ValidateResponse
  NO_RSA_RIGHT_ERROR_CODE = 40_440

  NO_RSA_RIGHT = raises ::NotFoundError,
    provider: 'CNAV',
    title: 'Absence de droit au RSA',
    detail: "La personne a été identifiée mais aucun droit au revenu de solidarité active n'a été trouvé pour son foyer.",
    attests: :not_eligible

  def call
    super

    unknown_provider_response! if json_body.dig('foyer', 'beneficiaire').blank?

    context.regime = regime
  end

  protected

  def resource_not_found!
    return no_rsa_right! if no_rsa_right?

    super
  end

  private

  def no_rsa_right?
    valid_json? && error_code_number == NO_RSA_RIGHT_ERROR_CODE
  end

  def no_rsa_right!
    error = build_declared_error(NO_RSA_RIGHT)
    error.add_meta(origin: regime) if regime

    fail_with_error!(error)
  end
end
