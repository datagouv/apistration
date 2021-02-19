require 'swagger_helper'

RSpec.describe 'RNM: Entreprises artisanales', type: :request do
  path '/v3/rnm/entreprises/{siren}' do
    get 'Récupération des informations d\'une entreprise artisanale' do
      tags 'Informations générales'

      produces 'application/json'

      parameter name: :siren, in: :path, type: :string

      parameter name: :context, in: :query, type: :string
      parameter name: :recipient, in: :query, type: :string
      parameter name: :object, in: :query, type: :string

      security [jwt_bearer_token: []]

      response '200', 'Entreprise found', vcr: { cassette_name: 'rnm_cma/valid_siren_json' }  do
        let(:siren) { valid_siren(:rnm_cma)}

        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: {
                  type: :string,
                  example: valid_siren(:rnm_cma),
                },
                attributes: {
                  type: :object,
                  properties: {
                    siren: {
                      type: :siren,
                      example: valid_siren(:rnm_cma),
                    },
                  },
                  required: %w[
                    siren
                  ],
                },
              },
              required: %w[
                id
              ],
            },
          },
          required: [
            :data,
          ]

        run_test!
      end
    end
  end
end
