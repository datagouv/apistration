require 'rack/utils'
require 'digest/sha2'

require_relative '../../app/services/rate_limiting_service.rb'
require_relative '../../app/lib/rate_limit_headers_middleware.rb'

class Rack::Attack
  class << self
    def throttle_by_group_of_endpoints(group_name:, limit:, endpoints:, period:)
      throttle(group_name, limit: limit, period: period) do |req|
        rate_limiting_service.discriminate_by_jwt_for_endpoints(req, endpoints)
      end
    end

    def throttle_by_single_endpoint(limit:, endpoints:, period:)
      endpoints.each do |endpoint|
        identifier = [endpoint[:controller], endpoint[:action]].join('_')

        throttle(identifier, limit: limit, period: period) do |req|
          rate_limiting_service.discriminate_by_jwt_for_endpoints(req, [endpoint])
        end
      end
    end

    private

    def rate_limiting_service
      @rate_limiting_service ||= RateLimitingService.new
    end
  end

  self.safelist('JWT whitelist') do |req|
    rate_limiting_service.whitelisted_access?(req)
  end

  self.blocklist('JWT blacklist') do |req|
    rate_limiting_service.blacklisted_access?(req)
  end

  throttle('API Particulier V2 global limit', limit: 20, period: 1) do |request|
    next if request.get_header('HTTP_X_API_KEY').blank? || !request.path.include?('/api/v2/') || !(request.host =~ /particulier/)

    Digest::SHA512.hexdigest(request.get_header('HTTP_X_API_KEY'))
  end

  Rails.configuration.throttle.each do |name, config|
    params = config.slice(:limit, :period, :endpoints)
    params[:group_name] = name if config[:throttle_type] == 'by_group_of_endpoints'

    public_send("throttle_#{config[:throttle_type]}", **params)
  end

  self.blocklisted_responder = lambda do |req|
    api = req.host.split('.').first

    error_format = req.env['PATH_INFO'].include?('/api/v2/') ? 'flat' : 'json_api'

    [
      401,
      { 'Content-Type' => 'application/json' },
      [ErrorsSerializer.new([BlacklistedTokenError.new(api)], format: error_format).to_json]
    ]
  end

  self.throttled_responder = lambda do |req|
    env = req.env

    headers = rate_limiting_service.build_rate_limit_headers(env['rack.attack.match_data'])

    retry_after = [(headers['RateLimit-Reset'].to_i - Time.now.to_i), 0].max
    headers.merge!(
      'Content-Type' => 'application/json',
      'Retry-After' => retry_after.to_s
    )

    error_format = req.env['PATH_INFO'].include?('/api/v2/') ? 'flat' : 'json_api'

    [
      429,
      headers,
      [ErrorsSerializer.new([TooManyRequestsError.new], format: error_format).to_json]
    ]
  end
end

Rails.configuration.middleware.insert_after Rack::Attack, RateLimitHeadersMiddleware

ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _request_id, req|
  req = req[:request]
  msg = ['BLOCKED', req.env['rack.attack.match_type'], req.ip, req.request_method, req.fullpath, ('"' + req.user_agent.to_s + '"')].join(' ')

  if %i[throttle blocklist].include?(req.env['rack.attack.match_type'])
    Rails.logger.error(msg)
  else
    Rails.logger.info(msg)
  end
end
