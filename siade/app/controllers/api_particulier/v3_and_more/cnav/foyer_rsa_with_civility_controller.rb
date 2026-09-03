class APIParticulier::V3AndMore::CNAV::FoyerRSAWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    civility_parameters.merge({ request_id: request.request_id })
  end

  def serializer_module
    ::APIParticulier::CNAV::FoyerRSASerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::CNAV::FoyerRSA)
  end
end
