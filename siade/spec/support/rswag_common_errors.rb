# rubocop:disable Metrics/ModuleLength
module RSwagCommonErrors
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

  def forbidden_france_connect_request(&block)
    describe 'with valid mandatory params but insufficient privileges on token' do
      response '403', 'Accès interdit' do
        before do
          mock_valid_france_connect_v2_checktoken
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

  def common_provider_errors_request(provider_name, organizer_klass, extra_errors = [], &block)
    response '502', 'Erreur du fournisseur' do
      provider_unknown_error = ProviderUnknownError.new(provider_name)

      stubbed_organizer_error(
        organizer_klass,
        provider_unknown_error
      )

      schema '$ref' => '#/components/schemas/Error'

      build_rswag_example(provider_unknown_error, :provider_unknown_error)

      Array(extra_errors).each do |error|
        build_rswag_example(error)
      end

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

  def common_network_error_request(provider_name, organizer_klass, &block)
    response '504', 'Erreur d\'intermédiaire' do
      schema '$ref' => '#/components/schemas/Error'

      provider_timeout_error = ProviderTimeoutError.new(provider_name)

      stubbed_organizer_error(
        organizer_klass,
        provider_timeout_error
      )

      build_rswag_example(provider_timeout_error, :timeout_error)
      build_rswag_example(ProviderUnavailable.new(provider_name), :provider_unavailable_error)
      build_rswag_example(NetworkError.new, :network_error)
      build_rswag_example(DnsResolutionError.new(provider_name), :dns_resolution_error)

      build_cnav_network_error_rswag_example if provider_name == 'CNAV'

      block.call if block_given?

      run_test!
    end
  end

  def build_cnav_network_error_rswag_example
    build_rswag_example(ProviderRateLimitingError.new('CNAV'), :provider_error)
  end

  def documents_errors(provider_name)
    BadFileFromProviderError::KIND_TO_SUBCODE.dup.keys.map do |subcode|
      BadFileFromProviderError.new(provider_name, subcode)
    end
  end

  # rubocop:disable RSpec/VerifiedDoubles
  def stubbed_organizer_error(organizer_klass, error)
    let(:organizer) { double('organizer', success?: false, errors: [error], mocked_data: nil, cacheable: false) }

    before do
      allow(organizer_klass).to receive(:call).and_return(organizer)
    end
  end
  # rubocop:enable RSpec/VerifiedDoubles
end
# rubocop:enable Metrics/ModuleLength
