Rails.application.routes.draw do
  draw(:api_entreprise)
  draw(:api_particulier)

  post '/api/reload-mocks', to: 'reload_mock_backend#create'

  match '*whatislove', to: 'errors#not_found', via: :all
end
