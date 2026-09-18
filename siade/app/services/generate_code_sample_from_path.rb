class GenerateCodeSampleFromPath
  PATHS_WITHOUT_AUDIT_PARAMS = %r{\A(/privileges|/v\d+/token/introspect)\z}

  def initialize(path, staging: false)
    @path = path
    @staging = staging
  end

  # rubocop:disable-next Layout/LineContinuationLeadingSpace
  def perform
    "curl -X GET \\\n" \
      "  -H \"Authorization: Bearer $token\" \\\n" \
      "  --url \"#{host}#{interpolated_path}#{query_params}\""
  end

  private

  attr_reader :path

  def host
    if @staging
      'https://staging.entreprise.api.gouv.fr'
    else
      'https://entreprise.api.gouv.fr'
    end
  end

  # rubocop:disable-next Metrics/MethodLength
  def interpolated_path
    path.gsub(/\{[^}]+\}/) do |parameter|
      case parameter[1..-2]
      when 'siret', 'siret_or_rna', 'siret_or_eori', 'siren_or_siret_or_rna', 'siren_or_siret_or_rnf'
        example_siret
      when 'siren', 'siren_or_rna'
        example_siret.first(9)
      when 'year'
        2019
      when 'month'
        11
      when 'document_id'
        '65419234a1f7d1f2ba09bd8c'
      else
        raise "#{parameter} is not supported"
      end
    end
  end

  def query_params
    return '' if path.match?(PATHS_WITHOUT_AUDIT_PARAMS)

    query_params = {
      recipient: recipient_siret,
      context: "Test de l'API",
      object: "Test de l'API"
    }.to_query

    "?#{query_params}"
  end

  def example_siret
    '13002526500013'
  end

  def recipient_siret
    '10000001700010'
  end
end
