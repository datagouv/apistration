module RSWagCommonsResponses
  def common_action_attributes
    produces 'application/json'

    parameter name: :context,
      in: :query,
      type: :string,
      description: SwaggerData.get('parameters.context.description'),
      example: SwaggerData.get('parameters.context.example'),
      required: true

    parameter name: :recipient,
      in: :query,
      type: :string,
      description: SwaggerData.get('parameters.recipient.description'),
      example: SwaggerData.get('parameters.recipient.example'),
      required: true

    parameter name: :object,
      in: :query,
      type: :string,
      description: SwaggerData.get('parameters.object.description'),
      example: SwaggerData.get('parameters.object.example'),
      required: true

    security [jwt_bearer_token: []]
  end

  def parameter_siren
    parameter name: :siren,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siren.description'),
      examples: SwaggerData.get('parameters.siren.examples')
  end

  def parameter_siret
    parameter name: :siret,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siret.description'),
      examples: SwaggerData.get('parameters.siret.examples')
  end

  def parameter_siret_or_rna
    parameter name: :siret_or_rna,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siret_or_rna.description'),
      examples: SwaggerData.get('parameters.siret_or_rna.examples')
  end

  def parameter_siret_or_eori
    parameter name: :siret_or_eori,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siret_or_eori.description'),
      examples: SwaggerData.get('parameters.siret_or_eori.examples')
  end

  def rate_limit_headers
    header 'RateLimit-Limit',
      schema: {
        type: :integer
      },
      description: 'La limite concernant l’endpoint appelé, soit le nombre de requête/minute.',
      example: 50

    header 'RateLimit-Remaining',
      schema: {
        type: :integer
      },
      description: 'Le nombre d’appels restants durant la période courante d’une minute.',
      example: 47

    header 'RateLimit-Reset',
      schema: {
        type: :integer
      },
      description: 'La fin de la période courante (en format timestamp)',
      example: 1637223155
  end

  def unauthorized_request(&block)
    describe 'with valid mandatory params but invalid token' do
      include_context 'Valid mandatory params and no token'

      response '401', 'Non autorisé' do
        block.call if block_given?

        schema '$ref' => '#/components/schemas/Error'

        run_test!
      end
    end
  end

  def forbidden_request(&block)
    describe 'with valid mandatory params but insufficient privileges on token' do
      include_context 'Valid mandatory params and unauthorized token'

      response '403', 'Accès interdit' do
        block.call if block_given?

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

      build_rswag_example(provider_unknown_error, :unknown_error)

      Array(extra_errors).each do |error|
        build_rswag_example(error)
      end

      block if block_given?

      run_test!
    end
  end

  def not_found_error_request(provider_name, organizer_klass, &block)
    response '404', 'Non trouvée' do
      block.call if block_given?

      stubbed_organizer_error(
        organizer_klass,
        NotFoundError.new(provider_name)
      )

      schema '$ref' => '#/components/schemas/Error'

      run_test!
    end
  end

  def unprocessable_entity_error_request(params, &block)
    response '422', 'Paramètre(s) invalide(s)' do
      block.call if block_given?

      schema '$ref' => '#/components/schemas/Error'

      Array(params).each do |param|
        build_rswag_example(UnprocessableEntityError.new(param), "unprocessable_entity_error_#{param}_error".to_sym)
      end

      %i[
        context
        object
        recipient
      ].each do |field|
        build_rswag_example(MissingMandatoryParamError.new(field), "missing_mandatory_params_#{field}_error".to_sym)
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

      block.call if block_given?

      run_test!
    end
  end

  # rubocop:disable RSpec/VerifiedDoubles
  def stubbed_organizer_error(organizer_klass, error)
    let(:organizer) { double('organizer', success?: false, errors: [error]) }

    before do
      allow(organizer_klass).to receive(:call).and_return(organizer)
    end
  end
  # rubocop:enable RSpec/VerifiedDoubles

  def build_rswag_example(error, key = nil)
    example 'application/json', key || error.title.parameterize.underscore.to_sym, {
      errors: [
        error.to_h
      ]
    }, error.title, error.detail
  end
end
