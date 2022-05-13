class API::PingController < ActionController::API
  def show
    render status: :ok
  end
end
