class Openapi::ErrorInjector
  def initialize(open_api, config_path:, api:)
    @open_api = open_api
    @api = api.to_sym
    @config = YAML.load_file(config_path)
    @builder = Openapi::ErrorExamplesBuilder.new
  end

  def perform
    open_api['paths'].each do |path, path_schema|
      path_schema.each_value do |operation|
        next unless operation.is_a?(Hash) && operation.key?('responses')
        next if operation['security'] == []

        inject_errors(path, operation)
      end
    end
  end

  private

  attr_reader :open_api, :api, :config, :builder

  def inject_errors(path, operation)
    responses = operation['responses']
    provider = nomenclature_provider(operation) || extract_provider(path)

    config['responses'].each do |status_code, error_config|
      next if responses.key?(status_code)
      next if error_config['requires_provider'] && provider.nil?

      response = build_response(error_config, provider)
      next if response.nil?

      responses[status_code] = response
    end
  end

  def build_response(error_config, provider)
    examples = build_examples(error_config, provider)

    return if examples.empty?

    response_hash(error_config['description'], examples)
  end

  def response_hash(description, examples)
    {
      'description' => description,
      'content' => {
        'application/json' => {
          'examples' => examples,
          'schema' => { '$ref' => '#/components/schemas/Error' }
        }
      }
    }
  end

  def build_examples(error_config, provider)
    return {} unless error_config.key?('examples')

    examples = {}

    error_config['examples'].each do |key, example_config|
      error = instantiate_error(example_config, provider)
      examples.merge!(builder.build_from_error(error, key))
    end

    examples
  end

  def instantiate_error(example_config, provider)
    klass = example_config['error_class'].constantize
    return klass.build_example(provider_name: provider) if example_config['build_example']

    args = resolve_args(example_config['args'], provider)

    if args.any?
      klass.new(*args)
    else
      klass.new
    end
  end

  def resolve_args(args, provider)
    return [] if args.nil?

    args.map do |arg|
      arg.is_a?(String) ? arg.gsub('%<provider>s', provider.to_s) : arg
    end
  end

  def nomenclature_provider(operation)
    nomenclature.dig('endpoints', operation.dig('responses', '200', 'x-operationId'), 'provider')
  end

  def nomenclature
    @nomenclature ||= ErrorsNomenclature.new(api).to_h
  end

  def extract_provider(path)
    ExtractProviderFromPath.new(path).perform
  end
end
