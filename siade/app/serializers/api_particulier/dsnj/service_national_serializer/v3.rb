class APIParticulier::DSNJ::ServiceNationalSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :en_regle, if: -> { scope?(:dsnj_service_national) }
  attribute :commentaires, if: -> { scope?(:dsnj_service_national) }
end
