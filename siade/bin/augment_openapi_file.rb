require 'yaml'
require 'active_support/all'

require_relative '../app/services/generate_code_sample_from_path'

open_api_path = File.expand_path('../../swagger/openapi.yaml', __FILE__)

open_api = YAML.load_file(open_api_path)

open_api['paths'].each do |path, schema|
  schema['get'].merge!(
    'x-codeSamples' => [
      {
        'lang'    => 'cURL',
        'label'   => 'Ligne de commande',
        'source'  => GenerateCodeSampleFromPath.new(path).perform
      }
    ]
  )
end

File.write(open_api_path, open_api.to_yaml)
