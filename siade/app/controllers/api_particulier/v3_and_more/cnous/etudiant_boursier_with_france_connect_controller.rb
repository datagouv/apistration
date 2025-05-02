class APIParticulier::V3AndMore::CNOUS::EtudiantBoursierWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::FranceConnectable

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
    civility_parameters_from_france_connect.merge({ token_id: current_user.token_id })
  end

  def serializer_module
    ::APIParticulier::CNOUS::EtudiantBoursier
  end

  def organizer
    @organizer ||= retrieve_payload_data(CNOUS::StudentScholarshipWithFranceConnect)
  end
end
