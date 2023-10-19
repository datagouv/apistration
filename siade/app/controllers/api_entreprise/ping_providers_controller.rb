class APIEntreprise::PingProvidersController < ApplicationController
  include HandlePingProviders

  def api_kind
    'api_entreprise'
  end

  def provider_param
    params[:provider_with_source]
  end
end
