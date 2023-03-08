require 'yaml'
require 'date'
require 'active_support/core_ext/hash'

def merge_openapi_particulier(partial_path)
  openapi_particulier_path = File.expand_path('../../swagger/openapi-particulier.yaml', __FILE__)
  openapi_particulier = YAML.load_file(openapi_particulier_path, permitted_classes: [Date], aliases: true)

  partial = YAML.load_file(partial_path, permitted_classes: [Date], aliases: true)

  merged_openapi = merge_openapi_paths(openapi_particulier, partial)

  File.write(openapi_particulier_path, merged_openapi.to_yaml)
end

def merge_openapi_paths(base_openapi, partial_openapi)
  base_openapi['paths'].merge!(partial_openapi['paths'])

  base_openapi
end

partial_path = File.expand_path('../../swagger/api_particulier_v2_partials/openapi-particulier-v2.yaml', __FILE__)

merge_openapi_particulier(partial_path)
