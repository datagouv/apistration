root = Rails.root
maintenances_path = root.join('config/maintenances.yml')
maintenances = YAML.load_file(maintenances_path, aliases: true)['production']

def augment_with_maintenances(schema, path, maintenances)
  path_regular_maintenances = (maintenances[ExtractProviderFromPath.new(path).perform] || {}).except('dates')

  schema['get'].merge!({
    'x-maintenances' => path_regular_maintenances.presence
  }.compact)
end

def augment_with_code_samples(schema, path)
  schema['get'].merge!({
    'x-codeSamples' => [
      {
        'lang' => 'cURL',
        'label' => 'Ligne de commande',
        'source' => GenerateCodeSampleFromPath.new(path).perform
      }
    ]
  }.compact)
end

APIS = {
  'entreprise' => {
    file: 'swagger/openapi-entreprise.yaml',
    config: 'config/openapi_common_errors/entreprise.yml',
    entreprise_augments: true
  },
  'particulier' => {
    file: 'swagger/openapi-particulier.yaml',
    config: 'config/openapi_common_errors/particulier.yml',
    entreprise_augments: false
  }
}.freeze

APIS.each_value do |api_config|
  open_api_path = root.join(api_config[:file])
  open_api = YAML.load_file(open_api_path, aliases: true)
  config_path = root.join(api_config[:config])

  Openapi::ErrorInjector.new(open_api, config_path: config_path).perform

  if api_config[:entreprise_augments]
    open_api['paths'].each do |path, schema|
      augment_with_maintenances(schema, path, maintenances)
      augment_with_code_samples(schema, path)
    end
  end

  File.write(open_api_path, open_api.to_yaml)
end
