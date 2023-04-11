class INSEE::SiegeDiffusableUniteLegale::ValidateResponse < INSEE::SiegeUniteLegale::ValidateResponse
  def call
    super

    resource_not_found! if siege_non_diffusable?
  end

  private

  def siege_non_diffusable?
    %w[N].include?(etablissement['statutDiffusionEtablissement'])
  end

  def etablissement
    json_body['etablissements'][0]
  end
end
