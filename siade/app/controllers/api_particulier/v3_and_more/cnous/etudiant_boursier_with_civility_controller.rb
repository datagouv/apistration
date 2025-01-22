class APIParticulier::V3AndMore::CNOUS::EtudiantBoursierWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  protected

  def transcogage?
    true
  end

  private

  def organizer_params
    civility_parameters
  end

  def serializer_module
    ::APIParticulier::CNOUS::EtudiantBoursier
  end

  def organizer
    @organizer ||= retrieve_payload_data(CNOUS::StudentScholarshipWithCivility)
  end
end
