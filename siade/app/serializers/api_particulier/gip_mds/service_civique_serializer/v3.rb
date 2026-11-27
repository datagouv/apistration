class APIParticulier::GIPMDS::ServiceCiviqueSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :organisme_accueil, if: -> { scope?(:gip_mds_service_civique_organisme_accueil) }
  attribute :dates, if: -> { scope?(:gip_mds_service_civique_dates) }
end
