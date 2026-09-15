class APIRequestFacade
  OPENAPI_SERVICES = {
    'entreprise' => -> { APIEntreprise::OpenAPIDefinition.instance },
    'particulier' => -> { APIParticulier::OpenAPIDefinition.instance }
  }.freeze

  FIXED_PARAMS = %w[recipient context object].freeze
  FIXED_HEADERS = %w[Cache-Control].freeze

  attr_reader :namespace, :selected_endpoint_uid

  def initialize(namespace:, selected_endpoint_uid: nil)
    @namespace = namespace
    @selected_endpoint_uid = selected_endpoint_uid
  end

  def api_identifier
    "api_#{namespace}"
  end

  def endpoints
    @endpoints ||= build_endpoints
  end

  def endpoints_grouped_by_tag
    endpoints.group_by { |e| e.open_api_definition&.dig('tags')&.first || 'Autre' }
      .transform_values { |eps| eps.map { |e| [e.title_with_version, e.uid] } }
  end

  def selected_endpoint
    return if selected_endpoint_uid.blank?

    endpoints.find { |e| e.uid == selected_endpoint_uid }
  end

  def parameters
    return [] unless selected_endpoint

    path_parameters + query_parameters
  end

  def header_parameters
    return [] unless selected_endpoint

    openapi_parameters.filter_map do |param|
      next if param['in'] != 'header' || FIXED_HEADERS.include?(param['name'])

      build_openapi_parameter(param)
    end
  end

  def execute_request(params)
    return unless selected_endpoint

    transformed_params = transform_params(params.except('headers'))
    request_headers = declared_headers(params['headers'])
    result = Siade::ManualRequest.new(
      endpoint_path: selected_endpoint.path,
      params: transformed_params,
      api: api_identifier,
      headers: request_headers
    ).call

    with_provider_response_extracted(result).merge(
      request_params: filtered_request_params(transformed_params),
      request_headers:
    )
  end

  private

  def openapi_service
    OPENAPI_SERVICES[namespace]&.call
  end

  def build_endpoints
    return [] unless openapi_service

    openapi_service.backend['paths'].filter_map { |path, definition|
      next if path.include?('france_connect')

      get_def = definition['get']
      next unless get_def

      OpenAPIEndpoint.new(path:, open_api_definition: get_def, api: api_identifier)
    }.sort_by(&:title)
  end

  def path_parameters
    selected_endpoint.path.scan(/\{(\w+)\}/).flatten.map do |name|
      APIRequestParameter.new(name:, required: true, location: 'path')
    end
  end

  def query_parameters
    openapi_parameters.filter_map do |param|
      next if param['in'] != 'query' || FIXED_PARAMS.include?(param['name'])

      build_openapi_parameter(param)
    end
  end

  def openapi_parameters
    selected_endpoint.open_api_definition&.dig('parameters') || []
  end

  def build_openapi_parameter(param)
    APIRequestParameter.new(
      name: param['name'],
      required: param['required'],
      location: param['in'],
      options: param.dig('schema', 'enum') || []
    )
  end

  def declared_headers(headers)
    return {} if headers.blank?

    header_parameters.map(&:name).index_with { |name| headers[name] }.compact_blank
  end

  def transform_params(params_hash)
    result = {}
    params_hash.each do |key, value|
      next if value.blank?

      if array_param?(key)
        result["#{key}[]"] = Array(value).compact_blank
      else
        result[key] = value
      end
    end
    result
  end

  def array_param?(key)
    array_param_names.include?(key)
  end

  def array_param_names
    @array_param_names ||= openapi_parameters
      .select { |p| p['name'].end_with?('[]') }
      .map { |p| p['name'].delete_suffix('[]') }
  end

  def filtered_request_params(params)
    params.reject { |key, _| FIXED_PARAMS.include?(key.to_s) }
  end

  def with_provider_response_extracted(result)
    payload = parse_payload(result[:body])
    provider_response = extract_provider_response(payload)

    result.merge(
      body: provider_response ? without_provider_response(payload).to_json : result[:body],
      provider_response:
    )
  end

  def parse_payload(body)
    JSON.parse(body.to_s)
  rescue JSON::ParserError
    nil
  end

  def extract_provider_response(payload)
    raw_response = payload&.dig('meta', 'provider_response')
    return if raw_response.blank?

    {
      status: raw_response['status'],
      headers: raw_response['headers'],
      body: raw_response['body']
    }
  rescue TypeError
    nil
  end

  def without_provider_response(payload)
    meta = payload['meta'].except('provider_response')

    return payload.except('meta') if meta.blank?

    payload.merge('meta' => meta)
  end
end
