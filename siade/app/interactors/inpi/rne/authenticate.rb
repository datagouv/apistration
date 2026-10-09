require 'jwt'

class INPI::RNE::Authenticate < AbstractGetToken
  class AccountRejected < StandardError; end

  ACCOUNT_POOLS = [nil, 'ping'].freeze
  ACCOUNT_SUFFIXES = ['', '_fallback'].freeze
  REJECTED_ACCOUNT_TTL = 24.hours

  def self.lift_all_rejections!
    ACCOUNT_POOLS.each { |pool| new(params: { inpi_rne_account_pool: pool }).lift_rejections! }
  end

  def call
    usable_account_suffixes.each do |suffix|
      @account_suffix = suffix

      return super
    rescue AccountRejected
      next
    end

    fail_to_request_provider!(MaintenanceError)
  end

  def lift_rejections!
    redis_service.del(*account_usernames.map { |account_username| rejected_account_key(account_username) })
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

  def usable_account_suffixes
    ACCOUNT_SUFFIXES
      .rotate(first_account_index)
      .reject { |suffix| rejected?(credential(:username, suffix)) }
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
