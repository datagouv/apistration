class APIEntreprise::V3AndMore::Qualifelec::CertificatsController < APIEntreprise::V3AndMore::MockedController
  protected

  def mocking_params
    {
      siret: params[:siret]
    }
  end

  def operation_id
    'api_entreprise_v3_qualifelec_certificats'
  end
end
