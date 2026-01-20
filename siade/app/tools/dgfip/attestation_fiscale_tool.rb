class DGFIP::AttestationFiscaleTool < DGFIP::AbstractDGFIPTool
  title 'DGFIP - Attestation fiscale'
  tool_name 'dgfip.attestation_fiscale'
  description "Attestation fiscale délivrée par la Direction générale des finances publiques (DGFIP), indiquant que l'entreprise est à jour de ses obligations fiscales."

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    DGFIP::AttestationFiscale
  end
end
