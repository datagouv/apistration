class APIParticulier::V3AndMore::MESRI::StatutEtudiantWithINEController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::GeneratesAttestationProof

  nomenclature organizers: { 3 => ::MESRI::StudentStatus::WithINE }

  private

  def api_params
    { ine: params[:ine] }
  end

  def organizer_params
    api_params.merge({ token_id: current_user.token_id })
  end

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(MESRI::StudentStatus::WithINE)
  end
end
