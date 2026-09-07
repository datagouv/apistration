# rubocop:disable-next Metrics/ModuleLength
module RSwagCommonErrors
  def unauthorized_request(&block)
    describe 'with valid mandatory params but invalid token' do
      include_context 'Valid mandatory params and no token'

      response '401', 'Non autorisé' do
        block.call if block_given?

        build_rswag_example(InvalidTokenError.new, :invalid_token_error)

        schema '$ref' => '#/components/schemas/Error'

        run_test!
      end
    end
  end

  MISSING_FRANCE_CONNECT_ACCESS_TOKEN_CODE = InvalidFranceConnectAccessTokenError.new(:missing_france_connect_access_token).code

  def missing_france_connect_bearer_token_request(&)
    describe 'with a valid API token but no FranceConnect bearer token' do
      let(:Authorization) { nil }

      before { stub_authentication_with_jwt_user }

      missing_france_connect_access_token_response(&)
    end
  end

  def missing_france_connect_access_token_response(&block)
    response '401', 'Non autorisé' do
      block.call if block_given?

      build_rswag_example(InvalidFranceConnectAccessTokenError.new(:missing_france_connect_access_token), :missing_france_connect_access_token_error)

      schema '$ref' => '#/components/schemas/Error'

      run_test! do |response|
        expect(JSON.parse(response.body).dig('errors', 0, 'code')).to eq(MISSING_FRANCE_CONNECT_ACCESS_TOKEN_CODE)
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

  def common_provider_errors_request(organizer_klass, &block)
    response '502', 'Erreur du fournisseur' do
      error = ProviderUnknownError.new(organizer_klass.provider_name)

      stubbed_organizer_error(organizer_klass, error)

      schema '$ref' => '#/components/schemas/Error'

      build_rswag_example(error)

      block.call if block_given?

      run_test!
    end
  end

  def unprocessable_content_error_request(params, &block)
    response '422', 'Paramètre(s) invalide(s)' do
      block.call if block_given?

      schema '$ref' => '#/components/schemas/Error'

      Array(params).each { |param| let(param) { 'invalid' } }

      build_rswag_example(UnprocessableEntityError.new(Array(params).first), :unprocessable_content_error)

      run_test!
    end
  end

  def common_network_error_request(organizer_klass, &block)
    response '504', 'Erreur d\'intermédiaire' do
      schema '$ref' => '#/components/schemas/Error'

      error = ProviderTimeoutError.new(organizer_klass.provider_name)

      stubbed_organizer_error(organizer_klass, error)

      build_rswag_example(error, :timeout_error)

      block.call if block_given?

      run_test!
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
