class APIParticulier::DSNJ::ServiceNationalSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :statut_service_national, if: -> { scope?(:dsnj_statut_service_national) }
  attribute :commentaires, if: -> { scope?(:dsnj_statut_service_national) }
end
