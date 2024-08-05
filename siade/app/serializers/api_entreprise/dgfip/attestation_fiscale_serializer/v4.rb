class APIEntreprise::DGFIP::AttestationFiscaleSerializer::V4 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :document_url

  attribute :document_url_expires_in do
    data.expires_in
  end

  attribute :date_delivrance_attestation do
    Time.zone.today
  end

  attribute :date_periode_analysee do
    Time.zone.today.beginning_of_month - 1.day
  end
end
