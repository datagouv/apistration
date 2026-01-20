class INPI::RNE::BeneficiairesEffectifsTool < ApplicationTool
  title 'INPI RNE - Bénéficiaires effectifs'
  tool_name 'inpi.rne.beneficiaires_effectifs'
  description "Liste des bénéficiaires effectifs d'une unité légale inscrite au répertoire national des entreprises (RNE)."

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    INPI::RNE::BeneficiairesEffectifs
  end
end
