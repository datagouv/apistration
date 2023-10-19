class APIParticulier::PingProvidersController < ApplicationController
  include HandlePingProviders

  def provider_param
    params[:provider]
  end
end
