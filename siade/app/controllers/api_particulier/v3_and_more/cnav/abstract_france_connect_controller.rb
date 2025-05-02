class APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::FranceConnectable

  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def cache_key
    "#{request.path}:#{civility_parameters_from_france_connect.to_query}"
  end

  private

  def organizer_params
    civility_parameters_from_france_connect.merge({ recipient: params[:recipient], request_id: request.request_id })
  end

  def organizer_class
    raise NotImplementedError
  end

  def expires_in
    1.hour
  end

  def organizer
    @organizer ||= retrieve_payload_data(organizer_class, cache: true, expires_in:)
  end
end
