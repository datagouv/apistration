class APIParticulier::V3AndMore::MESRI::StatutEtudiantWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  nomenclature organizers: { 3 => ::MESRI::StudentStatus::WithCivility }

  private

  def organizer_params
    civility_parameters
      .merge({ token_id: current_user.token_id })
  end

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(MESRI::StudentStatus::WithCivility)
  end
end
