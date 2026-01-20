class Infogreffe::MandatairesSociauxTool < ApplicationTool
  title 'Infogreffe - Mandataires sociaux'
  tool_name 'infogreffe.mandataires_sociaux'
  description "Liste des mandataires sociaux d'une société inscrite au registre du commerce et des sociétés (RCS), délivrée par Infogreffe."

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    Infogreffe::MandatairesSociaux
  end
end
