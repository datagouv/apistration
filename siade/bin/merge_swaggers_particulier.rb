require 'yaml'
require 'date'
require 'active_support/core_ext/hash'

def merge_openapi_particulier(partial_path)
  openapi_particulier_path = File.expand_path('../../swagger/openapi-particulier.yaml', __FILE__)
  openapi_particulier = YAML.load_file(openapi_particulier_path, permitted_classes: [Date], aliases: true)

  partial = YAML.load_file(partial_path, permitted_classes: [Date], aliases: true)

  openapi_particulier.deep_merge!(partial)

  File.write(openapi_particulier_path, openapi_particulier.to_yaml)
end

openapi_partial_directory = File.expand_path('../../swagger/api_particulier_v2_partials', __FILE__)
openapi_partials_paths = Dir.glob("#{openapi_partial_directory}/*.yaml")

openapi_partials_paths.each { |partial_path| merge_openapi_particulier(partial_path) }
