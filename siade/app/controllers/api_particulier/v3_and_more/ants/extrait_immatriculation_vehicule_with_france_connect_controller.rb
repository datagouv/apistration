class APIParticulier::V3AndMore::ANTS::ExtraitImmatriculationVehiculeWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::FranceConnectable
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
    civility_parameters_from_france_connect.merge(
      {
        immatriculation: params[:immatriculation],
        request_id: request.request_id
      }
    )
  end

  def serializer_module
    ::APIParticulier::ANTS::ExtraitImmatriculationVehiculeSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::ANTS::ExtraitImmatriculationVehicule)
  end
end
