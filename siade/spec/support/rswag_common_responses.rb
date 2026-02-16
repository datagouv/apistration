# rubocop:disable Metrics/ModuleLength
module RSwagCommonResponses
  def common_action_attributes
    produces 'application/json'

    parameter name: :recipient,
      in: :query,
      type: :string,
      description: SwaggerData.get('parameters.recipient.description'),
      example: SwaggerData.get('parameters.recipient.example'),
      required: true

    specific_api_entreprise_action_attributes if describe.metadata[:api] == :entreprise

    security [{ jwt_bearer_token: [] }]
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

    security [{ jwt_bearer_token: [] }]
  end

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

  # rubocop:disable Metrics/MethodLength
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
  # rubocop:enable Metrics/MethodLength

  def mandatory_params
    if describe.metadata[:api] == :entreprise
      %i[context object recipient]
    elsif describe.metadata[:api] == :particulier
      %i[recipient]
    end
  end

  # rubocop:disable Metrics/MethodLength
  def build_rswag_example(error, key = nil)
    payload = if metadata[:api] == :particulierv2
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
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/ModuleLength
