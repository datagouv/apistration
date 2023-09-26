# frozen_string_literal: true

class APIParticulier::PingProvidersController < ApplicationController
  def show
    render status: PingService.new('api_particulier', params[:provider]).perform
  end
end
