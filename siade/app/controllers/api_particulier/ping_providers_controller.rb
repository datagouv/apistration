class APIParticulier::PingProvidersController < ApplicationController
  include HandlePingProviders

  def token
    nil
  end

  def provider_param
    params[:provider]
  end
end
