class APIParticulier::V3AndMore::DSNJ::ServiceNationalWithCivilityController < APIParticulier::V3AndMore::BaseController
  include APIParticulier::CivilityParameters

  nomenclature organizers: { 3 => ::DSNJ::ServiceNational }

  private

  def organizer_params
    civility_parameters
  end

  def serializer_module
    ::APIParticulier::DSNJ::ServiceNationalSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::DSNJ::ServiceNational)
  end
end
