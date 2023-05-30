class APIParticulier::V2::CNAF::ComplementaireSanteSolidaireController < APIParticulier::MockedController
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
    'api_particulier_v2_cnaf_complementaire_sante_solidaire'
  end
end
