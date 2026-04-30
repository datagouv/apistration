require 'rack/utils'
require 'digest/sha2'

require_relative '../../app/services/rate_limiting_service'
require_relative '../../app/services/operation_id_resolver'
require_relative '../../app/lib/user_resolution_middleware'
require_relative '../../app/lib/rate_limit_headers_middleware'

Rails.configuration.middleware.insert_before Rack::Attack, UserResolutionMiddleware
require_relative '../../app/errors/application_error'
require_relative '../../app/errors/forbidden_error'
require_relative '../../app/errors/forbidden_ip_error'

class Rack::Attack
  class << self
    def throttle_by_group_of_endpoints(group_name:, limit:, endpoints:, period:)
      throttle(group_name, limit:, period:) do |req|
        rate_limiting_service.discriminate_by_authorization_request_for_endpoints(req, endpoints)
      end
    end

    def throttle_by_single_endpoint(limit:, endpoints:, period:)
      endpoints.each do |endpoint|
        identifier = [endpoint[:controller], endpoint[:action]].join('_')

        throttle(identifier, limit:, period:) do |req|
          rate_limiting_service.discriminate_by_authorization_request_for_endpoints(req, [endpoint])
        end
      end
    end

    private

    def rate_limiting_service
      @rate_limiting_service ||= RateLimitingService.new
    end
  end

  safelist('JWT whitelist') do |req|
    rate_limiting_service.whitelisted_access?(req)
  end

  blocklist('JWT blacklist') do |req|
    rate_limiting_service.blacklisted_access?(req)
  end

  blocklist('IP whitelist') do |req|
    rate_limiting_service.ip_forbidden_access?(req)
  end

  throttle(
    'custom_rate_limit',
    limit: proc { |req| rate_limiting_service.custom_rate_limit_for(req) || Float::INFINITY },
    period: 60
  ) do |req|
    next nil unless rate_limiting_service.custom_rate_limit?(req)

    rate_limiting_service.authorization_request_discriminator(req)
  end

  throttle('API Particulier V2 global limit', limit: 20, period: 1) do |request|
    next if request.get_header('HTTP_X_API_KEY').blank? || request.path.exclude?('/api/v2/') || request.host !~ /particulier/

    Digest::SHA512.hexdigest(request.get_header('HTTP_X_API_KEY'))
  end

  Rails.configuration.throttle.each do |name, config|
    operation_ids = config[:endpoints]

    case config[:throttle_type]
    when 'by_group_of_endpoints'
      throttle(name, limit: config[:limit], period: config[:period]) do |req|
        endpoints = operation_ids.map { |op_id| OperationIdResolver.resolve(op_id) }
        rate_limiting_service.discriminate_by_authorization_request_for_endpoints(req, endpoints)
      end
    when 'by_single_endpoint'
      operation_ids.each do |op_id|
        throttle(op_id, limit: config[:limit], period: config[:period]) do |req|
          endpoint = OperationIdResolver.resolve(op_id)
          rate_limiting_service.discriminate_by_authorization_request_for_endpoints(req, [endpoint])
        end
      end
    end
  end

  self.blocklisted_responder = lambda do |req|
    matched = req.env['rack.attack.matched']
    api = req.host.split('.').first
    error_format = req.env['PATH_INFO'].include?('/api/v2/') ? 'flat' : 'json_api'

    if matched == 'IP whitelist'
      [
        403,
        { 'Content-Type' => 'application/json' },
        [ErrorsSerializer.new([ForbiddenIpError.new(api)], format: error_format).to_json]
      ]
    else
      [
        401,
        { 'Content-Type' => 'application/json' },
        [ErrorsSerializer.new([BlacklistedTokenError.new(api)], format: error_format).to_json]
      ]
    end
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
  msg = ['BLOCKED', req.env['rack.attack.match_type'], req.ip, req.request_method, req.fullpath, "\"#{req.user_agent}\""].join(' ')

  if %i[throttle blocklist].include?(req.env['rack.attack.match_type'])
    Rails.logger.error(msg)
  else
    Rails.logger.info(msg)
  end
end
