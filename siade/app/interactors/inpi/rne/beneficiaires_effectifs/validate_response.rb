class INPI::RNE::BeneficiairesEffectifs::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if invalid_json?

    return if http_ok? && body_has_beneficiaires_effectifs?

    unknown_provider_response!
  end

  private

  def body_has_beneficiaires_effectifs?
    json_body['formality']['content']['personneMorale']['beneficiairesEffectifs'].present?
  end
end
