# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 903f3b3aca1a59a6cb1a53ab98f72c365486fc1f).
# Regenerate via clients/ruby/bin/sync_commons.

require_relative 'auth/bearer_token'

module ApiParticulier::Commons
  class Configuration
    PRODUCTION = :production
    STAGING = :staging
    ENVIRONMENTS = [PRODUCTION, STAGING].freeze

    DEFAULT_OPEN_TIMEOUT = 5
    DEFAULT_READ_TIMEOUT = 30

    attr_reader :base_url,
                :environment,
                :auth_strategy,
                :default_params,
                :open_timeout,
                :read_timeout,
                :retry,
                :logger,
                :user_agent,
                :adapter

    def initialize(
      base_urls:,
      token: nil,
      auth_strategy: nil,
      environment: PRODUCTION,
      base_url: nil,
      default_params: {},
      open_timeout: DEFAULT_OPEN_TIMEOUT,
      read_timeout: DEFAULT_READ_TIMEOUT,
      retry: nil,
      logger: nil,
      user_agent: nil,
      adapter: nil
    )
      @base_urls = base_urls
      resolved_env = resolve_environment(environment)
      @environment = resolved_env
      @explicit_base_url = !base_url.nil?
      @base_url = base_url || base_urls.fetch(resolved_env)
      @auth_strategy = auth_strategy || build_bearer_strategy(token)
      @default_params = default_params.freeze
      @open_timeout = open_timeout
      @read_timeout = read_timeout
      @retry = binding.local_variable_get(:retry)
      @logger = logger
      @user_agent = user_agent
      @adapter = adapter
      freeze
    end

    def with(**overrides)
      self.class.new(**current_attrs.merge(overrides))
    end
    alias copy with

    def production?
      environment == PRODUCTION
    end

    def staging?
      environment == STAGING
    end

    private

    def current_attrs
      {
        base_urls: @base_urls,
        auth_strategy: auth_strategy,
        environment: environment,
        base_url: @explicit_base_url ? base_url : nil,
        default_params: default_params,
        open_timeout: open_timeout,
        read_timeout: read_timeout,
        retry: @retry,
        logger: logger,
        user_agent: user_agent,
        adapter: adapter
      }
    end

    def resolve_environment(value)
      env = value.to_sym
      return env if ENVIRONMENTS.include?(env)

      raise ArgumentError, "environment must be one of #{ENVIRONMENTS.inspect}; got #{value.inspect}"
    end

    def build_bearer_strategy(token)
      return nil if token.nil?

      Auth::BearerToken.new(token)
    end
  end
end
