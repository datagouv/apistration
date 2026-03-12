class CNAVPingDriver < AbstractPingDriver
  attr_reader :make_request_interactor, :make_request_params,
    :token_interactor, :organizer_params

  private

  def health_check_ok?
    interactor = make_request_interactor.call(make_request_arguments)
    interactor.response&.code == '404'
  end

  attr_reader :provider

  def error_statuses
    %w[502 503 504]
  end

  def build_context(driver_params)
    @routes = driver_params.fetch(:routes)
    @make_request_interactor = Kernel.const_get(driver_params.fetch(:make_request))
    @make_request_params = driver_params.fetch(:params)
    @token_interactor = Kernel.const_get(driver_params.fetch(:token_interactor))
    @organizer_params = driver_params[:organizer_params]
    @provider = driver_params.fetch(:provider)
  end

  def make_request_arguments
    arguments = { params: make_request_params, token:, recipient: JwtTokenService::DINUM_SIRET }
    arguments.merge!(organizer_params) if organizer_params
    arguments.compact
  end

  def token
    @token ||= token_interactor.call(organizer_params).token
  end
end
