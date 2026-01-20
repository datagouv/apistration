class URSSAF::AttestationsSocialesTool < ApplicationTool
  title 'URSSAF - Attestation sociale'
  tool_name 'urssaf.attestations_sociales'
  description 'Retourne l\'attestation sociale délivrée à une entreprise acquittée de ses obligations de cotisations et contributions sociales auprès de l\'URSSAF Caisse nationale.'

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    URSSAF::AttestationsSociales
  end

  def self.format_params(params)
    params.merge(
      user_id: '1',
      recipient: dinum_siret
    )
  end

  def self.dinum_siret
    '13002526500013'
  end
end
