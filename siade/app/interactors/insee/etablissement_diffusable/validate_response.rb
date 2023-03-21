class INSEE::EtablissementDiffusable::ValidateResponse < INSEE::Etablissement::ValidateResponse
  def call
    resource_not_found! if http_ok? && non_diffusable?

    super
  end

  private

  def non_diffusable?
    %w[N P].include?(json_body['etablissement']['statutDiffusionEtablissement'])
  end
end
