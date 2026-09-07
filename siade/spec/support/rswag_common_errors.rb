# rubocop:disable-next Metrics/ModuleLength
module RSwagCommonErrors
  BASELINE_PROVIDER_ERROR_CLASSES = [
    ProviderUnknownError,
    ProviderInternalServerError,
    ProviderRateLimitingError,
    ProviderTemporaryError,
    SSLCertificateError
  ].freeze

  BASELINE_NETWORK_ERROR_CLASSES = [
    ProviderTimeoutError,
    ProviderUnavailable,
    NetworkError,
    DnsResolutionError
  ].freeze

  def unauthorized_request(&block)
    describe 'with valid mandatory params but invalid token' do
      include_context 'Valid mandatory params and no token'

      response '401', 'Non autorisé' do
        block.call if block_given?

        build_rswag_example(InvalidTokenError.new, :invalid_token_error)
        build_rswag_example(ExpiredTokenError.new, :expired_token_error)
        build_rswag_example(BlacklistedTokenError.new('entreprise'), :blacklisted_token_error)

        schema '$ref' => '#/components/schemas/Error'

        run_test!
      end
    end
  end

  MISSING_FC_BEARER_TOKEN_EXAMPLES = {
    missing_france_connect_access_token_error: -> { InvalidFranceConnectAccessTokenError.new(:missing_france_connect_access_token) },
    invalid_token_error: -> { InvalidTokenError.new },
    expired_token_error: -> { ExpiredTokenError.new },
    blacklisted_token_error: -> { BlacklistedTokenError.new('particulier') }
  }.freeze

  # rubocop:disable-next Metrics/AbcSize
  def missing_france_connect_bearer_token_request(&block)
    describe 'with a valid API token but no FranceConnect bearer token' do
      let(:Authorization) { nil }

      before { stub_authentication_with_jwt_user }

      response '401', 'Non autorisé' do
        block.call if block_given?

        MISSING_FC_BEARER_TOKEN_EXAMPLES.each do |key, builder|
          build_rswag_example(builder.call, key)
        end

        schema '$ref' => '#/components/schemas/Error'

        run_test! do |response|
          body = JSON.parse(response.body)
          expect(body.dig('errors', 0, 'code')).to eq('50004')
        end
      end
    end
  end

  def forbidden_france_connect_request(&block)
    describe 'with valid mandatory params but insufficient privileges on token' do
      response '403', 'Accès interdit' do
        before do
          mock_valid_france_connect_checktoken
        end

        block.call if block_given?

        build_rswag_example(InsufficientPrivilegesError.new('api_particulier'), :insufficient_privileges_error)

        schema '$ref' => '#/components/schemas/Error'

        run_test!
      end
    end
  end

  def forbidden_request(api_kind = 'api_entreprise', &block)
    describe 'with valid mandatory params but insufficient privileges on token' do
      include_context 'Valid mandatory params and unauthorized token'

      response '403', 'Accès interdit' do
        block.call if block_given?

        build_rswag_example(InsufficientPrivilegesError.new(api_kind), :insufficient_privileges_error)

        schema '$ref' => '#/components/schemas/Error'

        run_test!
      end
    end
  end

  def too_many_requests(provider, &block)
    describe 'when exceeding request limit' do
      include_context 'Valid params (mandatory and token)'

      response '429', 'Trop de requêtes' do
        block.call if block_given?

        stubbed_organizer_error(
          provider,
          TooManyRequestsError.new
        )

        build_rswag_example(TooManyRequestsError.new, :too_many_requests_error)

        schema '$ref' => '#/components/schemas/Error'

        run_test!
      end
    end
  end

  def provider_error_examples(organizer_klass, extra_errors)
    provider_name = organizer_klass.provider_name
    baseline_errors = BASELINE_PROVIDER_ERROR_CLASSES.map { |klass| klass.new(provider_name) }
    registry_errors = ErrorRegistry.examples_for_status(organizer_klass, 502, provider_name:)

    (baseline_errors + Array(extra_errors) + registry_errors).uniq(&:code)
  end

  def common_provider_errors_request(organizer_klass, extra_errors = nil, &block)
    response '502', 'Erreur du fournisseur' do
      errors = provider_error_examples(organizer_klass, extra_errors)

      stubbed_organizer_error(organizer_klass, errors.first)

      schema '$ref' => '#/components/schemas/Error'

      errors.each { |error| build_rswag_example(error) }

      block.call if block_given?

      run_test!
    end
  end

  def unprocessable_content_error_request(params, &block)
    response '422', 'Paramètre(s) invalide(s)' do
      block.call if block_given?

      schema '$ref' => '#/components/schemas/Error'

      Array(params).each do |param|
        let(param) { 'invalid' }

        build_rswag_example(UnprocessableEntityError.new(param), :"unprocessable_content_error_#{param}_error")
      end

      mandatory_params.each do |field|
        build_rswag_example(MissingMandatoryParamError.new(field), :"missing_mandatory_params_#{field}_error")
      end

      run_test!
    end
  end

  def network_error_examples(provider_name)
    {
      timeout_error: ProviderTimeoutError.new(provider_name),
      provider_unavailable_error: ProviderUnavailable.new(provider_name),
      network_error: NetworkError.new,
      dns_resolution_error: DnsResolutionError.new(provider_name)
    }
  end

  def common_network_error_request(organizer_klass, &block)
    response '504', 'Erreur d\'intermédiaire' do
      schema '$ref' => '#/components/schemas/Error'

      examples = network_error_examples(organizer_klass.provider_name)

      stubbed_organizer_error(organizer_klass, examples[:timeout_error])

      examples.each { |key, error| build_rswag_example(error, key) }

      build_cnav_network_error_rswag_example(organizer_klass) if organizer_klass <= CNAV::RetrieverOrganizer

      block.call if block_given?

      run_test!
    end
  end

  def build_cnav_network_error_rswag_example(organizer_klass)
    build_rswag_example(ProviderRateLimitingError.new(organizer_klass.provider_name), :provider_error)
  end

  def documents_errors(organizer_klass)
    BadFileFromProviderError::KIND_TO_SUBCODE.dup.keys.map do |subcode|
      BadFileFromProviderError.new(organizer_klass.provider_name, subcode)
    end
  end

  # rubocop:disable-next RSpec/VerifiedDoubles
  def stubbed_organizer_error(organizer_klass, error)
    let(:organizer) { double('organizer', success?: false, errors: [error], mocked_data: nil, cacheable: false) }

    before do
      allow(organizer_klass).to receive(:call).and_return(organizer)
    end
  end
end
