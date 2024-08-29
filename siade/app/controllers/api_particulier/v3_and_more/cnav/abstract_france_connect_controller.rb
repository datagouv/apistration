class APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::FranceConnectable
  include APIParticulier::CivilityParameters

  def show
    organizer = retrieve_payload_data(organizer_class)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    civility_parameters_from_france_connect.merge({ recipient: params[:recipient], request_id: request.request_id })
  end

  def organizer_class
    raise NotImplementedError
  end
end
