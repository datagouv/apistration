require 'jwt'

class INPI::RNE::Authenticate < AbstractGetToken
  class AccountRejected < StandardError; end

  ACCOUNT_POOLS = [nil, 'ping'].freeze
  ACCOUNT_SUFFIXES = ['', '_fallback'].freeze
  REJECTED_ACCOUNT_TTL = 24.hours
  INPI_RNE_PINGS = [
    %i[api_entreprise inpi/rne],
    %i[api_entreprise inpi/rne/actes_bilans]
  ].freeze

  def self.lift_all_rejections!
    ACCOUNT_POOLS.each { |pool| new(params: { inpi_rne_account_pool: pool }).lift_rejections! }
  end

  def call
    try_each_account(usable_account_suffixes) { return super }
    try_each_account(readmitted_account_suffixes) do
      token = super
      lift_rejections_up_to(last_inpi_rne_ping_success_at)

      return token
    end

    fail_to_request_provider!(MaintenanceError)
  end

  def lift_rejections!
    redis_service.del(readmission_claim_key, *account_usernames.map { |account_username| rejected_account_key(account_username) })
  end

  protected

  def request_params
    {
      username:,
      password:
    }
  end

  def client_url
    Siade.credentials[:inpi_rne_login_url]
  end

  def access_token(response)
    JSON.parse(response.body)['token']
  end

  def expires_in(response)
    token = access_token(response)

    JWT.decode(token, nil, false)[0]['exp'] - Time.now.to_i
  end

  def cache_key
    :"#{super}_#{username}"
  end

  def handle_empty_token(token, response)
    return super unless response.code.to_i == 401

    reject_account!
  end

  private

  def try_each_account(suffixes)
    suffixes.each do |suffix|
      @account_suffix = suffix

      yield
    rescue AccountRejected
      next
    end
  end

  def usable_account_suffixes
    ACCOUNT_SUFFIXES
      .rotate(first_account_index)
      .reject { |suffix| rejected?(credential(:username, suffix)) }
  end

  def readmitted_account_suffixes
    return [] unless inpi_rne_ping_succeeded_since_last_rejection? && claim_readmission!

    ACCOUNT_SUFFIXES.rotate(first_account_index)
  end

  def inpi_rne_ping_succeeded_since_last_rejection?
    last_rejection_at = account_usernames.filter_map { |account_username| rejected_at(account_username) }.max

    last_rejection_at.present? &&
      last_inpi_rne_ping_success_at.present? &&
      last_inpi_rne_ping_success_at > last_rejection_at
  end

  def claim_readmission!
    ping_success = last_inpi_rne_ping_success_at.to_f.to_s

    redis_service.getset(readmission_claim_key, ping_success) != ping_success
  end

  def lift_rejections_up_to(time)
    account_usernames.each do |account_username|
      account_rejected_at = rejected_at(account_username)

      redis_service.del(rejected_account_key(account_username)) if account_rejected_at && account_rejected_at <= time
    end
  end

  def last_inpi_rne_ping_success_at
    @last_inpi_rne_ping_success_at ||= INPI_RNE_PINGS
      .filter_map { |api_kind, identifier| PingService.new(api_kind, identifier).stored_last_ok_status }
      .max
  end

  def rejected_at(account_username)
    timestamp = redis_service.get(rejected_account_key(account_username))

    Time.zone.at(timestamp.to_f) if timestamp
  end

  def first_account_index
    rand(ACCOUNT_SUFFIXES.size)
  end

  def reject_account!
    MonitoringService.instance.track(:error, "INPI RNE authentication failed for username: #{username}")
    redis_service.set(rejected_account_key(username), Time.zone.now.to_f, ex: REJECTED_ACCOUNT_TTL.to_i)

    raise AccountRejected
  end

  def rejected?(account_username)
    redis_service.exists?(rejected_account_key(account_username))
  end

  def rejected_account_key(account_username)
    "inpi_rne_authenticate_failed_#{account_username}"
  end

  def readmission_claim_key
    "inpi_rne_readmission_#{account_pool_prefix}"
  end

  def account_usernames
    ACCOUNT_SUFFIXES.map { |suffix| credential(:username, suffix) }
  end

  def redis_service
    @redis_service ||= RedisService.new
  end

  def username
    credential(:username, @account_suffix)
  end

  def password
    credential(:password, @account_suffix)
  end

  def credential(name, suffix)
    Siade.credentials[:"#{account_pool_prefix}_#{name}#{suffix}"]
  end

  def account_pool_prefix
    ['inpi_rne_login', params[:inpi_rne_account_pool]].compact.join('_')
  end

  def params
    context.params || {}
  end
end
