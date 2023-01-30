require 'byebug'

lib_folder = File.expand_path('../lib', File.dirname(__FILE__))
$LOAD_PATH.unshift(lib_folder) unless $LOAD_PATH.include?(lib_folder)

require 'open_api_helpers'
require 'generate_payload_readme'

include OpenAPIHelpers

main_readme_path = File.expand_path('../payloads/README.md', File.dirname(__FILE__))
main_readme_stream = File.open(main_readme_path, 'w')

main_readme_stream.puts '# Payloads'
main_readme_stream.puts
main_readme_stream.puts 'Les chemins sans lien ne possèdent pas de payload: l\'environnement de test'
main_readme_stream.puts 'génère une payload par défaut basée sur la spécification OpenAPI associée.'

{
  'api_particulier' => 'API Particulier',
  'api_entreprise' => 'API Entreprise v3+',
}.each do |api_id, api_name|
  main_readme_stream.puts
  main_readme_stream.puts("## #{api_name}")
  main_readme_stream.puts

  schema = load_schema(api_id)

  schema['paths'].each do |api_path, api_path_spec|
    operation_id = api_path_spec['get']['responses']['200']['x-operationId']
    next unless operation_id

    title = api_path_spec['get']['summary']

    if File.exist?(File.join(root_path, 'payloads', operation_id))
      main_readme_stream.puts("* [#{title}](#{operation_id}) (`#{api_path}`)")

      GeneratePayloadReadme.new(operation_id, api_path_spec['get']['summary'], api_path).perform
    else
      main_readme_stream.puts("* #{title} (`#{api_path}`)")
    end
  end
end

GeneratePayloadReadme.new('france_connect', 'France Connect').perform
