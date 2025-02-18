class APIParticulier::V3AndMore::DSNJ::ServiceNationalWithFranceConnectController < APIParticulier::V3AndMore::BaseController
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
      prenoms: civility_parameters_from_france_connect[:prenoms]&.map(&:capitalize),
      nom_naissance: civility_parameters_from_france_connect[:nom_naissance]&.upcase
    )
  end

  def serializer_module
    ::APIParticulier::DSNJ::ServiceNationalSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DSNJ::ServiceNational)
  end
end
