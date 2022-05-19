Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'api.gouv.fr',
      'staging.api.gouv.fr',
      '*.entreprise.api.gouv.fr',
      'entreprise.api.gouv.fr'

    resource '*',
      headers: :any,
      methods: :any
  end

  allow do
    origins '*'
    resource '/v*/openapi.yaml',
      headers: :any,
      methods: :any
  end
end
