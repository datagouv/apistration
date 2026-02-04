class DGFIPPingDriver < ApplicationPingDriver
  PING_PARAMS = {
    request_id: '22222222-2222-2222-2222-222222222222',
    user_id: '22222222-2222-2222-2222-222222222222'
  }.freeze
  ERROR_RATIO_THRESHOLD = 0.1

  attr_reader :routes

  def perform
    return :bad_gateway unless etat_sante_ok?
    return :bad_gateway if error_ratio_too_high?

    :ok
  end

  private

  def etat_sante_ok?
    interactor = DGFIP::ADELIE::Ping::MakeRequest.call(
      params: PING_PARAMS,
      token:,
      recipient: JwtTokenService::DINUM_SIRET
    )
    interactor.response&.code == '200'
  end

  def error_ratio_too_high?
    total, errors = AccessLogPingView
      .where(route: routes)
      .pick(Arel.sql("COUNT(*), COUNT(*) FILTER (WHERE status IN ('503', '504'))"))

    return false if total.nil? || total.zero?

    errors.to_f / total >= ERROR_RATIO_THRESHOLD
  end

  def build_context(driver_params)
    @routes = driver_params.fetch(:routes)
  end

  def token
    @token ||= DGFIP::ADELIE::Authenticate.call.token
  end
end
