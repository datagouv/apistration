class CNAV::FoyerRSA::ValidateResponse < CNAV::ValidateResponse
  def call
    super

    unknown_provider_response! if json_body.dig('foyer', 'beneficiaire').blank?

    context.regime = regime
  end
end
