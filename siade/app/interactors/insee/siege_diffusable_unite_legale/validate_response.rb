class INSEE::SiegeDiffusableUniteLegale::ValidateResponse < INSEE::SiegeUniteLegale::ValidateResponse
  private

  def validate_ok_response
    super

    resource_not_found! if siege_non_diffusable?
  end

  def siege_non_diffusable?
    %w[N].include?(etablissement['statutDiffusionEtablissement'])
  end

  def etablissement
    json_body['etablissements'][0]
  end
end
