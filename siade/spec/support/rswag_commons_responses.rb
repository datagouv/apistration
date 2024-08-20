module RSWagCommonsResponses
  def common_action_attributes
    produces 'application/json'

    parameter name: :recipient,
      in: :query,
      type: :string,
      description: SwaggerData.get('parameters.recipient.description'),
      example: SwaggerData.get('parameters.recipient.example'),
      required: true

    specific_api_entreprise_action_attributes if describe.metadata[:api] == :entreprise

    security [jwt_bearer_token: []]
  end

  def specific_api_entreprise_action_attributes
    parameter name: :context,
      in: :query,
      type: :string,
      description: SwaggerData.get('parameters.context.description'),
      example: SwaggerData.get('parameters.context.example'),
      required: true

    parameter name: :object,
      in: :query,
      type: :string,
      description: SwaggerData.get('parameters.object.description'),
      example: SwaggerData.get('parameters.object.example'),
      required: true
  end

  def common_api_particulier_action_attributes
    produces 'application/json'

    parameter name: :recipient,
      in: :query,
      type: :string,
      description: SwaggerData.get('parameters.recipient.description'),
      example: SwaggerData.get('parameters.recipient.example'),
      required: true

    security [jwt_bearer_token: []]
  end

  def parameters_cnav_identite_pivot_nom_usage(required)
    parameter name: :nomUsage,
      in: :query,
      type: SwaggerData.get('parameters.civility.nomUsage.type'),
      description: SwaggerData.get('parameters.civility.nomUsage.description'),
      example: SwaggerData.get('parameters.civility.nomUsage.example'),
      required:
  end

  def parameters_cnav_identite_pivot_nom_naissance(required)
    parameter name: :nomNaissance,
      in: :query,
      type: SwaggerData.get('parameters.civility.nomNaissance.type'),
      description: SwaggerData.get('parameters.civility.nomNaissance.description'),
      example: SwaggerData.get('parameters.civility.nomNaissance.example'),
      required:
  end

  def parameters_cnav_identite_pivot_prenoms(required)
    parameter name: :'prenoms[]',
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.prenoms.type'),
        minItems: SwaggerData.get('parameters.civility.prenoms.minItems'),
        items: { type: :string },
        example: SwaggerData.get('parameters.civility.prenoms.example')
      },
      description: SwaggerData.get('parameters.civility.prenoms.description'),
      required:
  end

  def parameters_cnav_identite_pivot_annee_date_de_naissance(required)
    parameter name: :anneeDateDeNaissance,
      in: :query,
      type: SwaggerData.get('parameters.civility.anneeDateDeNaissance.type'),
      description: SwaggerData.get('parameters.civility.anneeDateDeNaissance.description'),
      example: SwaggerData.get('parameters.civility.anneeDateDeNaissance.example'),
      required:
  end

  def parameters_cnav_identite_pivot_mois_date_de_naissance(required)
    parameter name: :moisDateDeNaissance,
      in: :query,
      type: SwaggerData.get('parameters.civility.moisDateDeNaissance.type'),
      description: SwaggerData.get('parameters.civility.moisDateDeNaissance.description'),
      example: SwaggerData.get('parameters.civility.moisDateDeNaissance.example'),
      required:
  end

  def parameters_cnav_identite_pivot_jour_date_de_naissance(required)
    parameter name: :jourDateDeNaissance,
      in: :query,
      type: SwaggerData.get('parameters.civility.jourDateDeNaissance.type'),
      description: SwaggerData.get('parameters.civility.jourDateDeNaissance.description'),
      example: SwaggerData.get('parameters.civility.jourDateDeNaissance.example'),
      required:
  end

  def parameters_cnav_identite_pivot_code_cog_insee_commune_de_naissance(required)
    parameter name: :code_cog_insee_commune_de_naissance,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.type'),
        minLength: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.minLength'),
        maxLength: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.maxLength'),
        example: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.example')
      },
      description: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.description'),
      required:
  end

  def parameters_cnav_identite_pivot_code_pays_lieu_de_naissance(required)
    parameter name: :codePaysLieuDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.type'),
        minLength: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.minLength'),
        maxLength: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.maxLength'),
        example: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.example')
      },
      description: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.description'),
      required:
  end

  def parameters_cnav_identite_pivot_sexe_etat_civil(required)
    parameter name: :sexeEtatCivil,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.sexeEtatCivil.type'),
        enum: SwaggerData.get('parameters.civility.sexeEtatCivil.enum')
      },
      description: SwaggerData.get('parameters.civility.sexeEtatCivil.description'),
      example: SwaggerData.get('parameters.civility.sexeEtatCivil.example'),
      required:
  end

  def parameters_cnav_identite_pivot_nom_commune_naissance(required)
    parameter name: :nomCommuneNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.nomCommuneNaissance.type'),
        minLength: SwaggerData.get('parameters.civility.nomCommuneNaissance.minLength'),
        example: SwaggerData.get('parameters.civility.nomCommuneNaissance.example')
      },
      description: SwaggerData.get('parameters.civility.nomCommuneNaissance.description'),
      required:
  end

  def parameters_cnav_identite_pivot_code_cog_insee_departement_de_naissance(required)
    parameter name: :codeInseeDepartementNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.type'),
        minLength: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.minLength'),
        maxLength: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.maxLength'),
        example: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.example')
      },
      description: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.description'),
      required:
  end

  # rubocop:disable Metrics/AbcSize
  def parameters_cnav_identite_pivot(params: [], required: [])
    params.each do |param|
      public_send("parameters_cnav_identite_pivot_#{param.underscore}", required.include?(param))
    end
  end

  def parameters_cnav_identite_pivot_v2
    parameter name: :nomUsage,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomUsage.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomUsage.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomUsage.example'),
      required: false

    parameter name: :nomNaissance,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomNaissance.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomNaissance.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomNaissance.example'),
      required: false

    parameter name: :'prenoms[]',
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.prenoms.type'),
        minItems: SwaggerData.get('cnav.commons.cnav_identite_pivot.prenoms.minItems'),
        items: { type: :string },
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.prenoms.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.prenoms.description'),
      required: false

    parameter name: :anneeDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.anneeDateDeNaissance.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.anneeDateDeNaissance.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.anneeDateDeNaissance.example'),
      required: false

    parameter name: :moisDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.moisDateDeNaissance.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.moisDateDeNaissance.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.moisDateDeNaissance.example'),
      required: false

    parameter name: :jourDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.jourDateDeNaissance.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.jourDateDeNaissance.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.jourDateDeNaissance.example'),
      required: false

    parameter name: :codeInseeLieuDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.type'),
        minLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.maxLength'),
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.description'),
      required: false

    parameter name: :codePaysLieuDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.type'),
        minLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.maxLength'),
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.description'),
      required: false

    parameter name: :sexe,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.sexe.type'),
        enum: SwaggerData.get('cnav.commons.cnav_identite_pivot.sexe.enum')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.sexe.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.sexe.example'),
      required: false

    parameter name: :nomCommuneNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomCommuneNaissance.type'),
        minLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomCommuneNaissance.minLength'),
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomCommuneNaissance.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomCommuneNaissance.description'),
      required: false

    parameter name: :codeInseeDepartementNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.type'),
        minLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.maxLength'),
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.description'),
      required: false
  end
  # rubocop:enable Metrics/AbcSize

  def cacheable_request
    parameter name: 'Cache-Control',
      in: :header,
      type: :string,
      description: SwaggerData.get('parameters.header.cache_control.description')

    let(:'Cache-Control') { '' }
  end

  def cacheable_response(extra_description: '')
    header 'X-Response-Cached',
      schema: {
        type: :boolean,
        example: true,
        enum: [true, false],
        default: false
      },
      description: SwaggerData.get('response.headers.x_response_cached.description')

    header 'X-Cache-Expires-in',
      schema: {
        type: :number,
        nullable: true,
        example: 9001
      },
      description: (SwaggerData.get('response.headers.x_cache_expires_in.description') + " #{extra_description}").dup
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

  def parameter_siren_or_rna
    parameter name: :siren_or_rna,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siren_or_rna.description'),
      examples: SwaggerData.get('parameters.siren_or_rna.examples')
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

        build_rswag_example(InvalidTokenError.new, :invalid_token_error)
        build_rswag_example(ExpiredTokenError.new, :expired_token_error)
        build_rswag_example(BlacklistedTokenError.new('entreprise'), :blacklisted_token_error)

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

        build_rswag_example(InsufficientPrivilegesError.new('api_entreprise'), :insufficient_privileges_error)

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

  def unprocessable_entity_error_request(params, &block)
    response '422', 'Paramètre(s) invalide(s)' do
      block.call if block_given?

      schema '$ref' => '#/components/schemas/Error'

      Array(params).each do |param|
        let(param) { 'invalid' }

        build_rswag_example(UnprocessableEntityError.new(param), :"unprocessable_entity_error_#{param}_error")
      end

      mandatory_params.each do |field|
        build_rswag_example(MissingMandatoryParamError.new(field), :"missing_mandatory_params_#{field}_error")
      end

      run_test!
    end
  end

  def mandatory_params
    if describe.metadata[:api] == :entreprise
      %i[context object recipient]
    elsif describe.metadata[:api] == :particulier
      %i[recipient]
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

  def build_rswag_example(error, key = nil)
    payload = if metadata[:api] == :particulier
                {
                  error: error.kind,
                  reason: error.detail,
                  message: error.detail
                }
              else
                {
                  errors: [
                    error.to_h
                  ]
                }
              end

    example 'application/json', key || :"#{error.title.parameterize.underscore}_#{error.code}",
      payload,
      error.title,
      error.detail
  end
end
