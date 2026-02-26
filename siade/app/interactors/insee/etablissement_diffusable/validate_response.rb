class INSEE::EtablissementDiffusable::ValidateResponse < INSEE::Etablissement::ValidateResponse
  private

  def validate_ok_response
    resource_not_found! if non_diffusable?
  end

  def non_diffusable?
    %w[N].include?(json_body['etablissement']['statutDiffusionEtablissement'])
  end
end
