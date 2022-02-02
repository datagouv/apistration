require 'swagger_helper'

RSpec.describe 'MI : Associations', type: %i[request swagger] do
  path '/v3/mi/associations/{siret_or_rna}' do
    get SwaggerData.get('mi.association.title') do
      tags(*SwaggerData.get('mi.association.tags'))

      parameter_siret_or_rna

      common_action_attributes

      unauthorized_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      forbidden_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      describe 'with valid mandatory params', valid: true do
        response 200, 'Association found', vcr: { cassette_name: 'mi/associations/with_valid_rna' } do
          description SwaggerData.get('mi.association.description')

          schema build_rswag_response(
            id: valid_rna_id,
            type: 'association',
            attributes: SwaggerData.get('mi.association.attributes')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Association not found', vcr: { cassette_name: 'mi/associations/with_rna_not_found' } do
          let(:siret_or_rna) { non_existing_rna_id }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end

        response '422', 'Unprocessable entity', vcr: { cassette_name: 'mi/associations/unprocessable_entity' } do
          let(:siret_or_rna) { 'random_content' }

          schema '$ref' => '#/components/schemas/UnprocessableEntity'

          run_test!
        end
      end
    end
  end
end
