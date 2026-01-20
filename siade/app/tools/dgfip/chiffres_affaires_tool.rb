class DGFIP::ChiffresAffairesTool < DGFIP::AbstractDGFIPTool
  title "DGFIP - Chiffres d'affaires"
  tool_name 'dgfip.chiffres_affaires'
  description "Déclarations de chiffre d'affaires, des trois derniers exercices, faites auprès de la Direction générale des finances publiques (DGFIP)."

  input_schema(
    properties: {
      siret: { type: 'string', pattern: '^\d{14}$' }
    },
    required: %w[siret]
  )

  def self.organizer_class
    DGFIP::ChiffresAffaires
  end
end
