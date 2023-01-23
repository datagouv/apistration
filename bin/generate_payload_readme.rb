require 'byebug'

lib_folder = File.expand_path('../lib', File.dirname(__FILE__))
$LOAD_PATH.unshift(lib_folder) unless $LOAD_PATH.include?(lib_folder)

require 'open_api_helpers'

include OpenAPIHelpers

readme_path = File.expand_path('../payloads/README.md', File.dirname(__FILE__))
readme_stream = File.open(readme_path, 'w')

readme_stream.puts '# Payloads'
readme_stream.puts
readme_stream.puts 'Les chemins sans lien ne possèdent pas de payload: l\'environnement de test'
readme_stream.puts 'génère une payload par défaut basée sur la spécification OpenAPI associée.'

{
  'api_particulier' => 'API Particulier',
  'api_entreprise_v2' => 'API Entreprise v2 (deprecated)',
  'api_entreprise' => 'API Entreprise v3+',
}.each do |api_id, api_name|
  readme_stream.puts
  readme_stream.puts("## #{api_name}")
  readme_stream.puts

  schema = load_schema(api_id)

  schema['paths'].each do |path, path_spec|
    operation_id = path_spec['get']['responses']['200']['x-operationId']
    title = path_spec['get']['summary']
    next unless operation_id

    if File.exist?(File.join(root_path, 'payloads', operation_id))
      readme_stream.puts("* [#{title}](#{operation_id}) (`#{path}`)")
    else
      readme_stream.puts("* #{title} (`#{path}`)")
    end
  end
end
