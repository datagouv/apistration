Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'api.gouv.fr',
      '*.entreprise.api.gouv.fr',
      'entreprise.api.gouv.fr'

    resource '*',
      headers: :any,
      methods: [
        :get,
        :options,
      ]
  end
end
