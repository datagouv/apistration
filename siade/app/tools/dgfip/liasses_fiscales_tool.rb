class DGFIP::LiassesFiscalesTool < DGFIP::AbstractDGFIPTool
  title 'DGFIP - Liasses fiscales'
  tool_name 'dgfip/liasses_fiscales'
  description "Informations renseignées dans les liasses fiscales, issues des déclarations de résultat d'une entreprise auprès de la Direction générale des finances publiques (DGFIP)."

  input_schema(
    properties: {
      siren: { type: 'string', pattern: '^\d{9}$' },
      year: { type: 'string', pattern: '^\d{4}$' }
    },
    required: %w[siren]
  )

  def self.organizer_class
    DGFIP::LiassesFiscales
  end
end
