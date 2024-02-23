require 'yaml'
require 'date'
require 'active_support/core_ext/hash'

def merge_all_openapi_particulier
  partial_paths = %w[
    ../../swagger/api_particulier_open_api_static/v2.yaml
  ]

  partial_paths.each do |partial_path|
    partial = File.expand_path(partial_path, __FILE__)
    merge_openapi_particulier(partial)
  end
end

def merge_openapi_particulier(partial_path)
  partial = YAML.load_file(partial_path, permitted_classes: [Date], aliases: true)

  merged_openapi = merge_openapi_paths(openapi_particulier, partial)

  File.write(openapi_particulier_path, merged_openapi.to_yaml)
end

def merge_openapi_paths(base_openapi, partial_openapi)
  base_openapi['paths'].merge!(partial_openapi['paths'])

  base_openapi
end

def openapi_particulier_path
  File.expand_path('../swagger/openapi-particulier.yaml', __dir__)
end

def openapi_particulier
  YAML.load_file(openapi_particulier_path, permitted_classes: [Date], aliases: true)
end

merge_all_openapi_particulier
