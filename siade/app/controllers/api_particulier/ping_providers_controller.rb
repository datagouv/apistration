class APIParticulier::PingProvidersController < ApplicationController
  include HandlePingProviders

  def api_kind
    'api_particulier'
  end

  def provider_param
    params[:provider]
  end
end
