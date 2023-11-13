require 'rack/utils'
require 'digest/sha2'

require 'rate_limiting_service'
require 'rate_limit_headers_middleware'

class Rack::Attack
  class << self
    def throttle_zone(zone_name:, limit:, endpoints:, period:)
      throttle(zone_name, limit: limit, period: period) do |req|
        rate_limiting_service.discriminate_by_jwt_for_endpoints(req, endpoints)
      end
    end

    def throttle_exceptions(zone_name_prefix:, limit:, endpoints:, period:)
      endpoints.each do |endpoint|
        zone_name = [zone_name_prefix, endpoint[:controller], endpoint[:action]].join('_')
        throttle(zone_name, limit: limit, period: period) do |req|
          rate_limiting_service.discriminate_by_jwt_for_endpoints(req, [endpoint])
        end
      end
    end

    private

    def low_latency_documents_config
      throttle_config.fetch(:low_latency_documents)
    end

    def high_latency_documents_config
      throttle_config.fetch(:high_latency_documents)
    end

    def json_resources_config
      throttle_config.fetch(:json_resources)
    end

    def very_low_latency_json_resources_config
      throttle_config.fetch(:very_low_latency_json_resources)
    end

    def proxied_files_config
      throttle_config.fetch(:proxied_files)
    end

    def throttle_config
      Rails.configuration.throttle
    end

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

  throttle('API Particulier global limit', limit: 20, period: 1) do |request|
    next if request.get_header('HTTP_X_API_KEY').blank?

    Digest::SHA512.hexdigest(request.get_header('HTTP_X_API_KEY')) if request.host =~ /particulier/
  end

  throttle_zone(zone_name: 'low_latency_docs', **low_latency_documents_config)
  throttle_zone(zone_name: 'json_resources', **json_resources_config)

  throttle_exceptions(zone_name_prefix: 'high_latency_docs', **high_latency_documents_config)
  throttle_exceptions(zone_name_prefix: 'very_low_latency_json_resources', **very_low_latency_json_resources_config)
  throttle_exceptions(zone_name_prefix: 'proxied_files', **proxied_files_config)

  self.blocklisted_responder = lambda do |req|
    query_params = Rack::Utils.parse_nested_query(req.params['QUERY_STRING'])
    error_format = query_params['error_format'] || 'flat'
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
    error_format = query_params['error_format'] || :flat

    [
      429,
      headers,
      [ErrorsSerializer.new([TooManyRequestsError.new], format: error_format).to_json]
    ]
  end
end

Rails.configuration.middleware.insert_after Rack::Attack, RateLimitHeadersMiddleware
