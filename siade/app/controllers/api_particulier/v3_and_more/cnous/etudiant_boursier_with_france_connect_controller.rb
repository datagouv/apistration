class APIParticulier::V3AndMore::CNOUS::EtudiantBoursierWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::FranceConnectable
  include APIParticulier::CivilityParameters

  def show
    organizer = retrieve_payload_data(CNOUS::StudentScholarshipWithFranceConnect)

    if organizer.success?
      render json: serialize_data(organizer),
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
end
