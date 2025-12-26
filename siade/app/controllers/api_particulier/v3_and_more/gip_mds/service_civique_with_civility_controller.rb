class APIParticulier::V3AndMore::GIPMDS::ServiceCiviqueWithCivilityController < APIParticulier::V3AndMore::BaseController
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

  def transcogage?
    false
  end

  def organizer_params
    civility_parameters
  end

  def serializer_module
    ::APIParticulier::GIPMDS::ServiceCiviqueSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::GIPMDS::ServiceCivique)
  end
end
