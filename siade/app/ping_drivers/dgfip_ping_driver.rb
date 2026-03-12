class DGFIPPingDriver < AbstractPingDriver
  PING_PARAMS = {
    request_id: '22222222-2222-2222-2222-222222222222',
    user_id: '22222222-2222-2222-2222-222222222222'
  }.freeze

  PROVIDER = 'DGFIP - Adélie'.freeze

  private

  def health_check_ok?
    interactor = DGFIP::ADELIE::Ping::MakeRequest.call(
      params: PING_PARAMS,
      token:,
      recipient: JwtTokenService::DINUM_SIRET
    )
    interactor.response&.code == '200'
  end

  def provider
    PROVIDER
  end

  def build_context(driver_params)
    @routes = driver_params.fetch(:routes)
  end

  def token
    @token ||= DGFIP::ADELIE::Authenticate.call.token
  end
end
