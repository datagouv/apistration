# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 3f647e0d78209049ba64ba642be269590d3af52a).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'
begin
  require 'faraday/retry'
rescue LoadError
  # faraday-retry is optional; the :retry middleware is only used when the
  # consumer opts in.
end

require_relative 'middleware/authentication'
require_relative 'middleware/logging'
require_relative 'middleware/rate_limit'
require_relative 'middleware/error_handler'
require_relative 'middleware/envelope'
require_relative 'response'
require_relative 'siret'
require_relative 'errors'

module ApiParticulier::Commons
  class ClientBase
    attr_reader :configuration

    REQUIRED_PARAMS = %i[recipient context object].freeze
    SIRET_PARAMS = %i[recipient].freeze

    def initialize(configuration, product:)
      @configuration = configuration
      @product = product
      @connection = build_connection
    end

    def get(path, params: {}, headers: {})
      merged = merge_params(params)
      validate_required!(merged)
      validate_sirets!(merged)

      response = @connection.get(path, clean(merged), headers)
      build_response(response)
    end

    private

    def merge_params(params)
      @configuration.default_params.merge(params || {})
    end

    def required_params_for(_params)
      self.class::REQUIRED_PARAMS
    end

    def siret_params_for(_params)
      self.class::SIRET_PARAMS
    end

    def validate_required!(params)
      required_params_for(params).each do |key|
        next unless blank?(params[key]) && blank?(params[key.to_s])

        raise MissingParameterError, "required parameter #{key.inspect} is missing"
      end
    end

    def validate_sirets!(params)
      siret_params_for(params).each do |key|
        value = params[key] || params[key.to_s]
        next if value.nil?

        Siret.validate!(value, parameter: key)
      end
    end

    def blank?(value)
      value.nil? || (value.respond_to?(:empty?) && value.empty?)
    end

    def clean(params)
      params.reject { |_, v| v.nil? }
    end

    def build_response(response)
      Response.new(
        raw: response.body,
        http_status: response.status,
        headers: response.headers,
        rate_limit: response.env[Middleware::RateLimitParser::ENV_KEY]
      )
    end

    def build_connection
      cfg = @configuration
      Faraday.new(url: cfg.base_url) do |conn|
        conn.options.open_timeout = cfg.open_timeout
        conn.options.timeout = cfg.read_timeout

        conn.headers['User-Agent'] = cfg.user_agent if cfg.user_agent
        conn.headers['Accept'] = 'application/json'

        if cfg.retry && defined?(Faraday::Retry)
          conn.request :retry,
                       max: cfg.retry.fetch(:max, 2),
                       retry_statuses: cfg.retry.fetch(:on_status, [429, 502, 503]),
                       methods: %i[get],
                       interval: cfg.retry.fetch(:interval, 0.5),
                       backoff_factor: cfg.retry.fetch(:backoff_factor, 2),
                       exceptions: [
                         ApiParticulier::Commons::RateLimitError,
                         ApiParticulier::Commons::ProviderError,
                         ApiParticulier::Commons::ProviderUnavailableError,
                         ApiParticulier::Commons::TransportError
                       ]
        end

        conn.use Middleware::Authentication, auth_strategy: cfg.auth_strategy
        conn.use Middleware::Logging, logger: cfg.logger, redact_query: @product == :particulier

        conn.use Middleware::RateLimitParser
        conn.use Middleware::ErrorHandler
        conn.use Middleware::Envelope

        conn.adapter(cfg.adapter || Faraday.default_adapter)
      end
    end
  end
end
