Rails.application.routes.draw do
  GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Rails.application.credentials.workers_ui_username)) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Rails.application.credentials.workers_ui_password))
  end
  mount GoodJob::Engine => '/workers'

  get '/admin', to: redirect('/admin/users')

  namespace :admin do
    resources :users, only: %i[index edit update] do
      post :impersonate, on: :member
      post :stop_impersonating, on: :collection
      resources :tokens, only: %i[index new create] do
        resource :ban, only: %i[new create], controller: 'tokens/bans'
      end
    end
    resources :editors, only: %i[index edit update] do
      resources :editor_tokens, only: %i[create]
    end
    resources :provider_dashboards, only: %i[index show], path: 'providers' do
      member do
        get :global_section
        get :success_section
        get :duration_section
        get :consumers_section
        get :habilitations_section
      end
    end
    resources :audit_notifications, only: %i[index new create]
    resources :api_requests, only: %i[index create]
  end

  get '/editeur', to: redirect('/editeur/habilitations'), as: :editor

  namespace :editor, path: 'editeur' do
    resources :authorization_requests, only: %i[index], path: 'habilitations'
    resources :delegations, only: %i[index], path: 'delegations'
  end

  get '/fournisseur', to: 'provider/dashboard#index', as: :provider

  scope path: 'fournisseur/:provider_uid', as: :provider do
    get '/tableau-de-bord', to: 'provider/dashboard#show', as: :dashboard
    get '/tableau-de-bord/global', to: 'provider/dashboard#global_section', as: :dashboard_global
    get '/tableau-de-bord/success', to: 'provider/dashboard#success_section', as: :dashboard_success
    get '/tableau-de-bord/duration', to: 'provider/dashboard#duration_section', as: :dashboard_duration
    get '/tableau-de-bord/consumers', to: 'provider/dashboard#consumers_section', as: :dashboard_consumers
    get '/tableau-de-bord/habilitations', to: 'provider/dashboard#habilitations_section', as: :dashboard_habilitations
  end

  namespace :api do
    resources :frontal, only: :index
  end

  draw(:api_entreprise)
  draw(:api_particulier)
end
