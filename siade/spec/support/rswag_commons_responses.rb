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
    include_context 'Valid mandatory params and no token'

    response '403', 'Non autorisé' do
      description 'Le jeton est absent'

      block.call if block_given?

      run_test!
    end
  end

  def forbidden_request(&block)
    include_context 'Valid mandatory params and unauthorized token'

    response '403', 'Accès interdit' do
      description 'Le jeton ne possède pas les droits nécessaires'

      block.call if block_given?

      run_test!
    end
  end
end
