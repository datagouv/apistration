class APIParticulier::V3AndMore::DSNJ::ServiceNationalWithFranceConnectController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::RequiresFranceConnect

  nomenclature organizers: { 3 => ::DSNJ::ServiceNational }

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
