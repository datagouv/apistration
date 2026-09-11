class Errors::BaselineErrors
  PROVIDER_ERROR_CLASSES = [
    ProviderUnknownError,
    ProviderInternalServerError,
    ProviderRateLimitingError,
    ProviderTemporaryError,
    SSLCertificateError
  ].freeze

  NETWORK_ERROR_CLASSES = [
    ProviderTimeoutError,
    ProviderUnavailable,
    NetworkError,
    DnsResolutionError
  ].freeze

  MANDATORY_PARAMS = {
    entreprise: %i[context object recipient],
    particulier: %i[recipient]
  }.freeze

  attr_reader :api

  def initialize(api)
    @api = api.to_sym
  end

  def platform
    token_errors +
      mandatory_param_errors +
      [
        InsufficientPrivilegesError.new("api_#{api}"),
        BadRequestError.new,
        UnsupportedAPIVersionError.new('v1'),
        ConflictError.new,
        InvalidRecipientError.new,
        AmbiguousDelegationError.new,
        DelegationSiretMismatchError.new,
        TooManyRequestsError.new,
        NetworkError.new
      ]
  end

  def for_provider(provider_name)
    (PROVIDER_ERROR_CLASSES + NETWORK_ERROR_CLASSES - [NetworkError]).map { |klass| klass.build_example(provider_name:) } +
      [
        NotFoundError.build_example(provider_name:),
        MaintenanceError.build_example(provider_name:)
      ]
  end

  private

  def token_errors
    [
      InvalidTokenError.new,
      ExpiredTokenError.new("api_#{api}"),
      BlacklistedTokenError.new(api.to_s)
    ]
  end

  def mandatory_param_errors
    MANDATORY_PARAMS.fetch(api).map { |field| MissingMandatoryParamError.new(field) }
  end
end
