class Openapi::ErrorsNomenclatureStatusFiller
  def initialize(open_api, api:)
    @open_api = open_api
    @api = api.to_sym
  end

  def perform
    open_api['paths'].each_value do |path_schema|
      operation = path_schema['get']
      next if operation.nil? || operation['security'] == []

      errors_by_status = nomenclature_errors(operation.dig('responses', '200', 'x-operationId'))
      next if errors_by_status.nil?

      fill_missing_statuses(operation['responses'], errors_by_status)
    end
  end

  private

  attr_reader :open_api, :api

  def fill_missing_statuses(responses, errors_by_status)
    errors_by_status.each do |status, errors|
      next if responses.key?(status)

      responses[status] = response_hash(errors.first)
    end
  end

  def response_hash(error)
    {
      'description' => error['title'],
      'content' => {
        'application/json' => {
          'examples' => { "error_#{error['code']}" => example(error) },
          'schema' => { '$ref' => '#/components/schemas/Error' }
        }
      }
    }
  end

  def example(error)
    {
      'value' => { 'errors' => [error.slice('code', 'title', 'detail').merge('source' => nil, 'meta' => error.fetch('meta', {}))] },
      'summary' => error['title'],
      'description' => error['detail']
    }
  end

  def nomenclature_errors(operation_id)
    endpoint_errors = nomenclature.dig('endpoints', operation_id, 'errors')
    return if endpoint_errors.nil?

    nomenclature['platform_codes'].merge(endpoint_errors) { |_status, platform_errors, errors| errors + platform_errors }
  end

  def nomenclature
    @nomenclature ||= ErrorsNomenclature.new(api).to_h
  end
end
