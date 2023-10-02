class MakeRequestPingDriver < ApplicationPingDriver
  attr_reader :make_request_params, :make_request, :status_to_check

  def perform
    interactor = make_request.call(make_request_params)

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
  end
end
