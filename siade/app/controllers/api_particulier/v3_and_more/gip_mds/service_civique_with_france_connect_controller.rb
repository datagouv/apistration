class APIParticulier::V3AndMore::GIPMDS::ServiceCiviqueWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::RequiresFranceConnect
  include APIParticulier::CivilityParameters

  nomenclature organizers: { 3 => ::GIPMDS::ServiceCivique }

  private

  def organizer_params
    civility_parameters_from_france_connect
  end

  def serializer_module
    ::APIParticulier::GIPMDS::ServiceCiviqueSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::GIPMDS::ServiceCivique)
  end
end
