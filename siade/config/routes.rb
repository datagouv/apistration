Rails.application.routes.draw do
  constraints(DirectPodRequestConstraint.new) do
    get '/healthz', to: 'health#show'
    get '/healthz/database', to: 'health#database'
  end

  draw(:api_entreprise)
  draw(:api_particulier)

  post "/mcp", to: "mcp#handle"
  get  "/mcp", to: "mcp#handle"

  match '*whatislove', to: 'errors#not_found', via: :all
end
