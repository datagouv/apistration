Rswag::Api.configure do |c|
  # Specify a root folder where Swagger JSON files are located
  # This is used by the Swagger middleware to serve requests for API descriptions
  # NOTE: If you're using rswag-specs to generate Swagger, you'll need to ensure
  # that it's configured to generate files in the same folder
  c.swagger_root = Rails.root.join('swagger').to_s

  # Inject a lamda function to alter the returned Swagger prior to serialization
  # The function will have access to the rack env for the current request
  # For example, you could leverage this to dynamically assign the "host" property
  #
  # c.swagger_filter = lambda { |swagger, env| swagger['host'] = env['HTTP_HOST'] }
end

Rswag::Ui.configure do |c|
  # List the Swagger endpoints that you want to be documented through the swagger-ui
  # The first parameter is the path (absolute or relative to the UI host) to the corresponding
  # endpoint and the second is a title that will be displayed in the document selector
  # NOTE: If you're using rspec-api to expose Swagger files (under swagger_root) as JSON or YAML endpoints,
  # then the list below should correspond to the relative paths for those endpoints

  c.swagger_endpoint '/v3/openapi-entreprise.yaml', 'API Entreprise'

  # Add Basic Auth in case your API is private
  # c.basic_auth_enabled = true
  # c.basic_auth_credentials 'username', 'password'
end
