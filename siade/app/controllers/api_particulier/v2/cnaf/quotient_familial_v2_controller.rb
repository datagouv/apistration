class APIParticulier::V2::CNAF::QuotientFamilialV2Controller < APIParticulier::MockedController
  protected

  def mocking_params
    {
      codePaysLieuDeNaissance: params[:codePaysLieuDeNaissance],
      sexe: params[:sexe],
      nomUsage: params[:nomUsage],
      prenoms: params[:prenoms],
      anneeDateDeNaissance: params[:anneeDateDeNaissance],
      moisDateDeNaissance: params[:moisDateDeNaissance]
    }.compact
  end

  def operation_id
    'api_particulier_v2_cnaf_quotient_familial_v2'
  end
end
