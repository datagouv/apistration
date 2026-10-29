class APIParticulier::V3AndMore::MESRI::StatutEtudiantWithINEController < APIParticulier::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::MESRI::StudentStatus::WithINE }

  private

  def organizer_params
    {
      ine: params[:ine],
      token_id: current_user.token_id
    }
  end

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(MESRI::StudentStatus::WithINE)
  end
end
