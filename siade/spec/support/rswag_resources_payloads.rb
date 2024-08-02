module RSWagResourcesPayloads
  def build_rswag_response(attributes:, links: nil, meta: nil)
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: add_required_keys_to_all_type_object(attributes),
          required: attributes.keys,
          additionalProperties: false
        }
      }.merge(
        build_rswag_links(links)
      ).merge(
        build_rswag_meta(meta)
      ),
      required: %w[data links meta]
    }
  end

  def build_rswag_response_api_particulier(attributes:)
    {
      type: :object,
      properties: add_required_keys_to_all_type_object(attributes)
    }
  end

  # rubocop:disable Metrics/ParameterLists
  def build_rswag_response_collection(properties: nil, links: nil, meta: nil, item_links: nil, item_meta: nil, example: nil, required: nil)
    {
      type: :object,
      properties: {
        data: {
          type: :array,
          items: {
            type: :object,
            properties: {
              data: {
                type: :object,
                properties: add_required_keys_to_all_type_object(properties),
                required: required || properties.keys
              }
            }.merge(
              build_rswag_links(item_links)
            ).merge(
              build_rswag_meta(item_meta)
            )
          }
        }
      }.merge(
        build_rswag_meta(meta)
      ).merge(
        build_rswag_links(links)
      ),
      required: build_rswag_collection_required_keys(meta)
    }.merge(build_custom_example(example))
  end
  # rubocop:enable Metrics/ParameterLists

  def build_rswag_document_response(document_url_properties: {}, links: nil, meta: nil)
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: {
            document_url: {
              type: :string
            }.merge(document_url_properties),
            expires_in: {
              type: :integer,
              example: 7889238,
              description: "Nombre de secondes avant l'expiration de l'url associée à l'attribut document_url : cette durée correspond généralement à 24h."
            }
          },
          required: %w[document_url expires_in]
        }
      }.merge(
        build_rswag_links(links)
      ).merge(
        build_rswag_meta(meta)
      ),
      required: %w[data links meta]
    }
  end

  def build_rswag_meta(meta)
    if meta.blank?
      return {
        meta: {
          type: :object
        }
      }
    end

    {
      meta: {
        type: :object,
        properties: meta,
        required: meta.keys,
        additionalProperties: false
      }
    }
  end

  def build_rswag_links(links)
    if links.blank?
      return {
        links: {
          type: :object
        }
      }
    end

    {
      links: {
        type: :object,
        properties: links,
        required: links.keys,
        additionalProperties: false
      }
    }
  end

  def build_rswag_data_required_keys(meta, links)
    required = %w[
      id
      type
      attributes
    ]

    required << 'meta' if meta.present?
    required << 'links' if links.present?

    required
  end

  def build_rswag_collection_item_required_keys(links)
    required = %w[
      id
      type
      attributes
    ]

    required << 'links' if links.present?

    required
  end

  def build_rswag_collection_required_keys(meta)
    required = %w[
      data
    ]

    required << 'meta' if meta.present?

    required
  end

  def add_required_keys_to_all_type_object(attributes)
    attributes.each do |key, schema|
      next unless schema['type'] == 'object'

      attributes[key]['required'] = schema['required'] || schema['properties'].keys
      attributes[key]['properties'] = add_required_keys_to_all_type_object(attributes[key]['properties'])
    end

    attributes
  end

  def build_custom_example(example)
    return {} if example.blank?

    {
      example:
    }
  end
end
