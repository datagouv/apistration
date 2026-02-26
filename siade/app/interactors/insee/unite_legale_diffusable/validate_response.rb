class INSEE::UniteLegaleDiffusable::ValidateResponse < INSEE::UniteLegale::ValidateResponse
  def call
    resource_not_found! if http_ok? && valid_json? && non_diffusable?

    super
  end

  private

  def non_diffusable?
    %w[N].include?(json_body['uniteLegale']['statutDiffusionUniteLegale'])
  end
end
