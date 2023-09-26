class APIEntreprise::PingProvidersController < ApplicationController
  def show
    render status: PingService.new('api_entreprise', params[:provider_with_source]).perform
  end
end
