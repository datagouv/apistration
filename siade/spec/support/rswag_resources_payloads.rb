module RSWagResourcesPayloads
  def build_rswag_document_properties_response(siret:, document_url_extra_properties: {})
    {
      type: :object,
      properties: {
        data: {
          type: :object,
          properties: {
            id: {
              type: :string,
              example: siret
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
                  type: :string,
                  example: 'https://storage.entreprise.api.gouv.fr/siade/1569139162-b99824d9c764aae19a862a0af-document.pdf',
                  description: 'Lien vers le document. Ce document est automatiquement supprimé au bout de 3 mois.'
                }.merge(document_url_extra_properties)
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
end
