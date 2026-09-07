class Openapi::ErrorsNomenclatureLinker
  ERROR_STATUS = /\A[45]\d\d\z/
  SITES = {
    entreprise: 'https://entreprise.api.gouv.fr',
    particulier: 'https://particulier.api.gouv.fr'
  }.freeze
  ERRORS_PATHS = {
    entreprise: '/errors',
    particulier: '/api/errors'
  }.freeze

  def initialize(open_api, api:)
    @open_api = open_api
    @api = api.to_sym
  end

  def perform
    open_api['paths'].each do |path, path_schema|
      operation = path_schema['get']
      next if operation.nil? || operation['security'] == []

      operation_id = operation.dig('responses', '200', 'x-operationId')
      next unless documented_operation_ids.include?(operation_id)

      link_error_responses(operation, operation_id, path)
    end
  end

  private

  attr_reader :open_api, :api

  def link_error_responses(operation, operation_id, path)
    operation['responses'].each do |status, response|
      next unless status.to_s.match?(ERROR_STATUS)

      response['description'] = "#{response['description']}\n\n#{reference(operation_id, path)}"
    end
  end

  def reference(operation_id, path)
    reference = "L'exemple ci-dessous n'en est qu'un parmi d'autres : la liste complète des codes erreurs de cet endpoint est disponible sur #{errors_url}?operation_id=#{operation_id}"
    fiche = fiche_url(path)

    reference += ", et commentée dans la section « Erreurs » de #{fiche}" if fiche

    "#{reference}."
  end

  def errors_url
    "#{SITES.fetch(api)}#{ERRORS_PATHS.fetch(api)}"
  end

  def fiche_url(path)
    uid = fiche_uids[path]

    "#{SITES.fetch(api)}/catalogue/#{uid}#erreurs" if uid
  end

  def documented_operation_ids
    @documented_operation_ids ||= ErrorsNomenclature.new(api).to_h['endpoints'].keys.to_set
  end

  def fiche_uids
    @fiche_uids ||= Rails.root.glob("config/endpoints/api_#{api}/**/*.yml").each_with_object({}) do |file, result|
      [*YAML.safe_load_file(file, aliases: true)['fiche']].each do |fiche|
        result[fiche['path']] = fiche['uid']
      end
    end
  end
end
