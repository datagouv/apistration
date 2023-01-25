class ReloadMockBackendController < ApplicationController
  def create
    if Rails.env.staging?
      MockDataBackend.reset!

      render status: :ok, json: { message: 'Mock backend reloaded' }
    else
      render status: :forbidden
    end
  end
end
