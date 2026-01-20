class INSEE::EtablissementTool < ApplicationTool
  title 'INSEE - Etablissement'
  tool_name 'insee.etablissement'
  description 'Informations générales concernant un établissement inscrit au répertoire Sirene. Avec les données protégées des établissements en diffusion partielle.'

  input_schema(
    properties: {
      siret: { type: 'string', pattern: '^\d{14}$' }
    },
    required: %w[siret]
  )

  def self.organizer_class
    INSEE::Etablissement
  end
end
