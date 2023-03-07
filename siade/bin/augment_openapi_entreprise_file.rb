require 'yaml'
require 'active_support/all'

require_relative '../app/services/generate_code_sample_from_path'
require_relative '../app/services/extract_provider_from_path'

open_api_path = File.expand_path('../../swagger/openapi-entreprise.yaml', __FILE__)
open_api = YAML.load_file(open_api_path)
maintenances_path = File.expand_path('../../config/maintenances.yml', __FILE__)
maintenances = YAML.load_file(maintenances_path, aliases: true)['production']

open_api['paths'].each do |path, schema|
  path_regular_maintenances = (maintenances[ExtractProviderFromPath.new(path).perform] || {}).except('dates')

  schema['get'].merge!({
      'x-codeSamples' => [
        {
          'lang'    => 'cURL',
          'label'   => 'Ligne de commande',
          'source'  => GenerateCodeSampleFromPath.new(path).perform
        }
      ],
      'x-maintenances' => path_regular_maintenances.present? ? path_regular_maintenances : nil,
    }.compact
  )
end

File.write(open_api_path, open_api.to_yaml)
