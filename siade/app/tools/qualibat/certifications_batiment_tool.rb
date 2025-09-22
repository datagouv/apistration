class QUALIBAT::CertificationsBatimentTool < ApplicationTool
  title 'QUALIBAT - Certifications bâtiment'
  tool_name 'qualibat/certifications_batiment'
  description "Permet d'obtenir les certifications bâtiment d'une entreprise à partir de son SIREN sous format PDF"

  input_schema(
    properties: {
      siret: { type: 'string', pattern: '^\d{14}$' }
    },
    required: %w[siret]
  )

  def self.organizer_class
    QUALIBAT::CertificationsBatiment
  end

  def self.protected_data?
    false
  end

  def self.format_params(params)
    params.merge(api_version: '4')
  end
end
