class MakeRequestPingDriver < ApplicationPingDriver
  attr_reader :make_request_params, :make_request, :status_to_check, :token_interactor

  def perform
    interactor = make_request.call(make_request_arguments)

    if status_to_check == interactor.response.code
      :ok
    else
      :bad_gateway
    end
  end

  private

  def build_context(driver_params)
    @make_request_params = driver_params.fetch(:params)
    @make_request = Kernel.const_get(driver_params.fetch(:make_request))
    @status_to_check = driver_params.fetch(:status_to_check).to_s
    @token_interactor = driver_params[:token_interactor] ? Kernel.const_get(driver_params.fetch(:token_interactor)) : nil
  end

  def make_request_arguments
    {
      params: make_request_params,
      token:
    }.compact
  end

  def token
    return unless token_interactor

    @token ||= token_interactor.call.token
  end
end
