class APIParticulier::V3AndMore::ANTS::DossierImmatriculationWithFranceConnectController < APIParticulier::V3AndMore::BaseController
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
    civility_parameters_from_france_connect.merge({ immatriculation: params[:immatriculation] })
  end

  def serializer_module
    ::APIParticulier::ANTS::DossierImmatriculationSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::ANTS::DossierImmatriculation)
  end
end
