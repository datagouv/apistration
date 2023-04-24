class APIParticulier::V2::CNAF::QuotientFamilialV2Controller < APIParticulierController
  def show
    return render not_implemented_error unless Rails.env.staging?

    mocked_data = MockService.new(operation_id, mocking_params).mock
    render json: mocked_data[:payload], status: mocked_data[:status]
  end

  private

  def not_implemented_error
    error_json(NotImplementedYetError.new, status: :not_implemented)
  end

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
