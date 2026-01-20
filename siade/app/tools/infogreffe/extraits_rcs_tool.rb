class Infogreffe::ExtraitsRCSTool < ApplicationTool
  title 'Infogreffe - Extraits RCS / KBIS'
  tool_name 'infogreffe.extraits_rcs'
  description "Permet d'obtenir les extraits RCS et KBIS d'une entreprise à partir de son SIREN"

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    Infogreffe::ExtraitsRCS
  end
end
