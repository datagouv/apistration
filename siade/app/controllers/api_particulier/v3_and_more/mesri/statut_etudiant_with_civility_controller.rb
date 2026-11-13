class APIParticulier::V3AndMore::MESRI::StatutEtudiantWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters
  include APIParticulier::GeneratesAttestationProof

  nomenclature organizers: { 3 => ::MESRI::StudentStatus::WithCivility }

  private

  def attestation_proof_enabled?
    !Rails.env.production?
  end

  def api_params
    civility_parameters
  end

  def organizer_params
    api_params
      .merge({ token_id: current_user.token_id })
  end

  def serializer_module
    ::APIParticulier::MESRI::StatutEtudiantSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(MESRI::StudentStatus::WithCivility)
  end
end
