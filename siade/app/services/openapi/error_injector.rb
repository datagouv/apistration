class Openapi::ErrorInjector
  PATH_PARAM_REGEX = /\{(\w+)\}/

  def initialize(open_api, config_path:)
    @open_api = open_api
    @config = YAML.load_file(config_path)
    @builder = Openapi::ErrorExamplesBuilder.new
  end

  def perform
    open_api['paths'].each do |path, path_schema|
      path_schema.each_value do |operation|
        next unless operation.is_a?(Hash) && operation.key?('responses')

        inject_errors(path, operation)
      end
    end
  end

  private

  attr_reader :open_api, :config, :builder

  def inject_errors(path, operation)
    responses = operation['responses']
    provider = extract_provider(path)

    config['responses'].each do |status_code, error_config|
      next if responses.key?(status_code)
      next if error_config['requires_provider'] && provider.nil?

      response = build_response(path, error_config, provider)
      next if response.nil?

      responses[status_code] = response
    end

    merge_422_if_needed(path, responses)
  end

  def build_response(path, error_config, provider)
    examples = build_examples(error_config, provider)
    add_mandatory_params_examples(examples, path, error_config)

    return if examples.empty?

    response_hash(error_config['description'], examples)
  end

  def add_mandatory_params_examples(examples, path, error_config)
    return unless error_config.key?('mandatory_params')

    path_params = extract_path_params(path)
    mandatory_params = error_config['mandatory_params'].map(&:to_sym)
    examples.merge!(builder.build_422_for_params(path_params: path_params, mandatory_params: mandatory_params))
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

  def merge_422_if_needed(path, responses)
    error_config = config.dig('responses', '422')
    return unless error_config
    return unless responses.key?('422')

    path_params = extract_path_params(path)
    mandatory_params = error_config['mandatory_params'].map(&:to_sym)
    extra_examples = builder.build_422_for_params(path_params: path_params, mandatory_params: mandatory_params)

    existing_examples = responses.dig('422', 'content', 'application/json', 'examples') || {}
    extra_examples.each do |key, value|
      existing_examples[key] ||= value
    end
  end

  def extract_provider(path)
    ExtractProviderFromPath.new(path).perform
  end

  def extract_path_params(path)
    path.scan(PATH_PARAM_REGEX).flatten.map(&:to_sym)
  end
end
