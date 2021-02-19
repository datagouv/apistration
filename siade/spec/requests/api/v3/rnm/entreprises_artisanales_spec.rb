require 'swagger_helper'

RSpec.describe 'RNM: Entreprises artisanales', type: :request do
  path '/v3/rnm/entreprises/{siren}' do
    get 'Récupération des informations d\'une entreprise artisanale' do
      tags 'Informations générales'

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
          let(:siren) { valid_siren(:rnm_cma) }

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
end
