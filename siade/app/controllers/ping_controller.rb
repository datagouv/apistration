class PingController < ApplicationController
  def show
    render status: :ok
  end
end
