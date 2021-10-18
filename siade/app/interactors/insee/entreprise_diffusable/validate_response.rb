class INSEE::EntrepriseDiffusable::ValidateResponse < INSEE::Entreprise::ValidateResponse
  def call
    resource_not_found! if http_ok? && non_diffusable?

    super
  end

  private

  def non_diffusable?
    json_body['uniteLegale']['statutDiffusionUniteLegale'] == 'N'
  end
end
