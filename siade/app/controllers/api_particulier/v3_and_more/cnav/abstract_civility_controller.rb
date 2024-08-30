class APIParticulier::V3AndMore::CNAV::AbstractCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  def show
    organizer = retrieve_payload_data(organizer_class, cache: true, expires_in:)

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

  def cache_key
    "#{request.path}:#{api_params.to_query}"
  end

  private

  def api_params
    civility_parameters(requireds: %i[
      nomNaissance
      codePaysLieuDeNaissance
      sexeEtatCivil
      codeCogInseeCommuneDeNaissance
    ])
  end

  def organizer_params
    api_params
      .merge({ recipient: current_user.siret, request_id: request.request_id })
  end

  def organizer_class
    raise NotImplementedError
  end

  def expires_in
    1.hour
  end
end
