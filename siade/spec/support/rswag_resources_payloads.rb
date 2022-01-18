module RSWagResourcesPayloads
  # rubocop:disable Naming/MethodParameterName
  def build_rswag_response(id:, type:, attributes:, links: nil, meta: nil)
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: {
            id: {
              type: :string,
              example: id
            },
            type: {
              type: :string,
              example: type,
              enum: [type]
            },
            attributes: {
              type: :object,
              properties: add_required_keys_to_all_type_object(attributes),
              required: attributes.keys
            }
          }.merge(
            build_rswag_links(links)
          ).merge(
            build_rswag_meta(meta)
          ),
          required: build_rswag_data_required_keys(links, meta)
        }
      },
      required: %w[data]
    }
  end

  def build_rswag_response_collection(type:, properties: nil, links: nil, meta: nil)
    {
      type: :object,
      properties: {
        data: {
          type: :array,
          items: {
            type: type,
            properties: add_required_keys_to_all_type_object(properties)
          }.merge(
            build_rswag_meta(meta)
          )
        }
      }.merge(
        build_rswag_links(links)
      ),
      required: %w[data meta]
    }
  end

  def build_rswag_document_response(id:, document_url_properties: {})
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: {
            id: {
              type: :string,
              example: id
            },
            type: {
              type: :string,
              example: :document,
              enum: %w[document]
            },
            attributes: {
              type: :object,
              properties: {
                document_url: {
                  type: :string
                }.merge(document_url_properties)
              },
              required: %w[document_url]
            }
          },
          required: %w[
            id
            type
            attributes
          ]
        }
      },
      required: %w[data]
    }
  end
  # rubocop:enable Naming/MethodParameterName

  def build_rswag_meta(meta)
    return {} if meta.blank?

    {
      meta: {
        type: :object,
        properties: meta,
        required: meta.keys
      }
    }
  end

  def build_rswag_links(links)
    return {} if links.blank?

    {
      links: {
        type: :object,
        properties: links,
        required: links.keys
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

  def add_required_keys_to_all_type_object(attributes)
    attributes.each do |key, schema|
      next unless schema['type'] == 'object'

      attributes[key]['required'] = schema['properties'].keys
      attributes[key]['properties'] = add_required_keys_to_all_type_object(attributes[key]['properties'])
    end

    attributes
  end
end
