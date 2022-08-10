Rails.application.routes.draw do
  draw(:api_entreprise)
  draw(:api_particulier)

  match '*whatislove', to: 'errors#not_found', via: :all
end
