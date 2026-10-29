class APIParticulier::V3AndMore::ANTS::ExtraitImmatriculationVehiculeWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::RequiresFranceConnect
  include APIParticulier::CivilityParameters

  nomenclature organizers: { 3 => ::ANTS::ExtraitImmatriculationVehicule }

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
