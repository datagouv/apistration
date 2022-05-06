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

  # rubocop:disable Metrics/AbcSize
  def common_provider_errors_request(provider_name, organizer_klass, extra_errors = [], &block)
    response '502', 'Erreur du fournisseur' do
      provider_unknown_error = ProviderUnknownError.new(provider_name)

      stubbed_organizer_error(
        organizer_klass,
        provider_unknown_error
      )

      schema '$ref' => '#/components/schemas/Error'

      example 'application/json', :unknown_error, {
        errors: [
          provider_unknown_error.to_h
        ]
      }, provider_unknown_error.title, provider_unknown_error.detail

      Array(extra_errors).each do |error|
        example 'application/json', error.title.parameterize.underscore.to_sym, {
          errors: [
            error.to_h
          ]
        }, error.title, error.detail
      end

      block if block_given?

      run_test!
    end
  end
  # rubocop:enable Metrics/AbcSize

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

  # rubocop:disable Metrics/AbcSize
  def unprocessable_entity_error_request(params, &block)
    response '422', 'Paramètre(s) invalide(s)' do
      block.call if block_given?

      schema '$ref' => '#/components/schemas/Error'

      Array(params).each do |param|
        unprocessable_entity_error = UnprocessableEntityError.new(param)

        example 'application/json', "unprocessable_entity_error_#{param}_error".to_sym, {
          errors: [
            unprocessable_entity_error.to_h
          ]
        }, unprocessable_entity_error.title, unprocessable_entity_error.detail
      end

      %i[
        context
        object
        recipient
      ].each do |field|
        missing_mandatory_param_error = MissingMandatoryParamError.new(field)

        example 'application/json', "missing_mandatory_params_#{field}_error".to_sym, {
          errors: [
            missing_mandatory_param_error.to_h
          ]
        }, missing_mandatory_param_error.title, missing_mandatory_param_error.detail
      end

      run_test!
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def common_network_error_request(provider_name, organizer_klass, &block)
    response '504', 'Erreur d\'intermédiaire' do
      schema '$ref' => '#/components/schemas/Error'

      provider_timeout_error = ProviderTimeoutError.new(provider_name)

      stubbed_organizer_error(
        organizer_klass,
        provider_timeout_error
      )

      example 'application/json', :timeout_error, {
        errors: [
          provider_timeout_error.to_h
        ]
      }, provider_timeout_error.title, provider_timeout_error.detail

      provider_unavailable_error = ProviderUnavailable.new(provider_name)
      example 'application/json', :provider_unavailable_error, {
        errors: [
          provider_unavailable_error.to_h
        ]
      }, provider_unavailable_error.title, provider_unavailable_error.detail

      network_error = NetworkError.new
      example 'application/json', :network_error, {
        errors: [
          network_error.to_h
        ]
      }, network_error.title, network_error.detail

      dns_resolution_error = DnsResolutionError.new(provider_name)
      example 'application/json', :dns_resolution_error, {
        errors: [
          dns_resolution_error.to_h
        ]
      }, dns_resolution_error.title, dns_resolution_error.detail

      block.call if block_given?

      run_test!
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable RSpec/VerifiedDoubles
  def stubbed_organizer_error(organizer_klass, error)
    let(:organizer) { double('organizer', success?: false, errors: [error]) }

    before do
      allow(organizer_klass).to receive(:call).and_return(organizer)
    end
  end
  # rubocop:enable RSpec/VerifiedDoubles
end
