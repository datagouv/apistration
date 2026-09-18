module RSwagResourcesPayloads
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

  def build_rswag_response_api_particulier_v2(attributes:)
    {
      type: :object,
      properties: add_required_keys_to_all_type_object(attributes)
    }
  end

  # rubocop:disable-next Metrics/ParameterLists
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
    promote_scopes_to_extensions!(attributes)

    attributes.each do |key, schema|
      next unless schema['type'] == 'object'

      attributes[key]['required'] = schema['required'] || schema['properties'].keys
      attributes[key]['properties'] = add_required_keys_to_all_type_object(attributes[key]['properties'])
    end

    attributes
  end

  def promote_scopes_to_extensions!(node)
    case node
    in Hash
      node['x-scope'] = node.delete('scope') if node['scope']
      node.each_value { |child| promote_scopes_to_extensions!(child) }
    in Array
      node.each { |child| promote_scopes_to_extensions!(child) }
    else
      nil
    end
  end

  def build_custom_example(example)
    return {} if example.blank?

    {
      example:
    }
  end

  def build_rswag_introspection_response
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: introspection_attributes,
          required: introspection_attributes.keys.map(&:to_s),
          additionalProperties: false
        },
        links: {
          type: :object
        },
        meta: {
          type: :object
        }
      },
      required: %w[data links meta]
    }
  end

  def introspection_attributes
    {
      id: {
        type: :string,
        title: 'Identifiant du jeton',
        description: "Identifiant unique du jeton (claim `jti`). C'est cet identifiant qu'il faut communiquer au support.",
        example: 'f5d5cb02-185a-426f-b3f4-99a25ce6cdf4'
      },
      type: {
        type: :string,
        enum: %w[standard editeur france_connect],
        title: 'Type de jeton',
        description: "`standard` : jeton délivré pour une demande d'habilitation. `editeur` : jeton d'éditeur, agissant par délégation. `france_connect` : jeton utilisé pour les appels FranceConnectés.",
        example: 'standard'
      },
      scopes: {
        type: :array,
        items: { type: :string },
        title: 'Périmètres de données accessibles',
        description: 'Liste des périmètres (scopes) accordés au jeton. Les données hors de ces périmètres sont masquées des réponses.',
        example: %w[attestations_fiscales attestations_sociales]
      },
      demande_acces_id: {
        type: :string,
        nullable: true,
        title: "Identifiant de la demande d'habilitation",
        description: "Identifiant DataPass de la demande d'habilitation à l'origine du jeton. Pour un jeton éditeur, identifiant de la demande d'habilitation déléguée, une fois le paramètre `recipient` renseigné.",
        example: '12345'
      },
      siret_souscripteur: {
        type: :string,
        nullable: true,
        title: 'SIRET du souscripteur',
        description: "SIRET de l'organisation à laquelle le jeton a été délivré. Pour un jeton éditeur, SIRET de l'organisation ayant délégué son habilitation, une fois le paramètre `recipient` renseigné.",
        example: '13002526500013'
      },
      date_emission: {
        type: :string,
        format: 'date-time',
        nullable: true,
        title: "Date d'émission du jeton",
        description: 'Date à laquelle le jeton a été émis (claim `iat`).',
        example: '2024-01-15T09:00:00+01:00'
      },
      date_expiration: {
        type: :string,
        format: 'date-time',
        nullable: true,
        title: "Date d'expiration du jeton",
        description: 'Date à laquelle le jeton cesse de fonctionner (claim `exp`). Pensez à demander son renouvellement avant cette date.',
        example: '2025-07-15T09:00:00+02:00'
      },
      duree_validite_restante_en_secondes: {
        type: :integer,
        nullable: true,
        title: 'Durée de validité restante',
        description: "Nombre de secondes restantes avant l'expiration du jeton.",
        example: 15_552_000
      },
      rate_limit_par_minute: {
        type: :integer,
        nullable: true,
        title: 'Limite de débit par minute',
        description: "Nombre maximum d'appels par minute accordé au jeton. `null` lorsque aucune limite spécifique n'est configurée.",
        example: 2000
      },
      delegation: {
        type: :object,
        nullable: true,
        title: 'Délégation utilisée',
        description: 'Délégation résolue pour un jeton éditeur, lorsque le paramètre `recipient` est renseigné. `null` dans tous les autres cas.',
        properties: {
          id: {
            type: :string,
            title: 'Identifiant de la délégation',
            example: 'a31c6e1b-0a2f-4e8b-9a31-9b3d1f9a51c2'
          },
          siret_delegant: {
            type: :string,
            title: 'SIRET du délégant',
            description: "SIRET de l'organisation ayant délégué son habilitation à l'éditeur.",
            example: '13002526500013'
          }
        },
        required: %w[id siret_delegant],
        additionalProperties: false
      }
    }
  end
end
