class APIParticulier::V3AndMore::CNAV::PrimeActiviteWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  def show
    organizer = retrieve_payload_data(CNAV::PrimeActivite)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def transcogage?
    true
  end

  private

  def organizer_params
    civility_parameters(requireds: %i[
      nomNaissance
      codePaysLieuDeNaissance
      sexeEtatCivil
      codeCogInseeCommuneDeNaissance
    ])
      .merge({ recipient: current_user.siret, request_id: request.request_id })
  end

  def serializer_module
    ::APIParticulier::CNAV::PrimeActivite
  end
end
