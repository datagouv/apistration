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
    next if request.get_header('HTTP_X_API_KEY').blank?

    Digest::SHA512.hexdigest(request.get_header('HTTP_X_API_KEY')) if request.host =~ /particulier/
  end

  Rails.configuration.throttle.each do |name, config|
    params = config.slice(:limit, :period, :endpoints)
    params[:group_name] = name if config[:throttle_type] == 'by_group_of_endpoints'

    public_send("throttle_#{config[:throttle_type]}", **params)
  end

  self.blocklisted_responder = lambda do |req|
    query_params = Rack::Utils.parse_nested_query(req.params['QUERY_STRING'])
    error_format = query_params['error_format'] || :json_api
    api = req.host.split('.').first

    [
      401,
      { 'Content-Type' => 'application/json' },
      [ErrorsSerializer.new([BlacklistedTokenError.new(api)], format: error_format).to_json]
    ]
  end

  self.throttled_responder = lambda do |req|
    env = req.env

    headers = rate_limiting_service.build_rate_limit_headers(env['rack.attack.match_data'])

    headers.merge!(
      'Content-Type' => 'application/json',
      'Retry-After' => (headers['RateLimit-Reset'].to_i - Time.now.to_i).to_s,
    )

    query_params = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
    error_format = query_params['error_format'] || :json_api

    [
      429,
      headers,
      [ErrorsSerializer.new([TooManyRequestsError.new], format: error_format).to_json]
    ]
  end
end

Rails.configuration.middleware.insert_after Rack::Attack, RateLimitHeadersMiddleware
