class MakeRequestPingDriver < ApplicationPingDriver
  attr_reader :make_request_params, :make_request, :status_to_check, :body_to_check, :token_interactor, :organizer_params

  def perform
    interactor = within_provider_timeout { make_request.call(make_request_arguments) }

    if expected_response?(interactor.response)
      :ok
    else
      :bad_gateway
    end
  end

  private

  def expected_response?(response)
    return false unless status_to_check == response&.code

    body_to_check.nil? || response.body.to_s.include?(body_to_check)
  end

  def build_context(driver_params)
    @make_request_params = driver_params.fetch(:params)
    @make_request = Kernel.const_get(driver_params.fetch(:make_request))
    @status_to_check = driver_params.fetch(:status_to_check).to_s
    @body_to_check = driver_params[:body_to_check]
    @token_interactor = driver_params[:token_interactor] ? Kernel.const_get(driver_params.fetch(:token_interactor)) : nil
    @organizer_params = driver_params[:organizer_params]
  end

  def make_request_arguments
    arguments = {
      params: make_request_params,
      token:,
      recipient: JwtTokenService::DINUM_SIRET
    }

    arguments.merge!(organizer_params) if organizer_params

    arguments.compact
  end

  def token
    return unless token_interactor

    @token ||= token_interactor.call(organizer_params).token
  end
end
