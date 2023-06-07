class APIEntreprise::V3AndMore::Qualifelec::CertificatsController < APIEntreprise::V3AndMore::MockedController
  protected

  def mocking_params
    {
      siret: params[:siret]
    }.compact
  end

  def operation_id
    'api_entreprise_v3_and_more_qualifelec_certificats'
  end
end
