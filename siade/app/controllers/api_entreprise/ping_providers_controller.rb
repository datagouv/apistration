class APIEntreprise::PingProvidersController < ApplicationController
  include HandlePingProviders

  def token
    nil
  end

  def provider_param
    params[:provider_with_source]
  end
end
