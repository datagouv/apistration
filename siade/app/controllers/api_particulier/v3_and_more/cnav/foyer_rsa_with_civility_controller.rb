class APIParticulier::V3AndMore::CNAV::FoyerRSAWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  nomenclature organizers: { 3 => ::CNAV::FoyerRSA }

  private

  def organizer_params
    civility_parameters.merge({ request_id: request.request_id })
  end

  def serializer_module
    ::APIParticulier::CNAV::FoyerRSASerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::CNAV::FoyerRSA)
  end
end
