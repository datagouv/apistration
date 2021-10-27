require 'swagger_helper'

RSpec.describe 'MI : Associations', type: %i[request swagger] do
  path '/v3/mi/associations/{siret_or_rna}' do
    get SwaggerInformation.get('mi.association.title') do
      tags(*SwaggerInformation.get('mi.association.tags'))

      common_action_attributes

      parameter name: :siret_or_rna, in: :path, type: :string

      unauthorized_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      forbidden_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      describe 'with valid mandatory params', valid: true do
        response 200, 'Association found', vcr: { cassette_name: 'mi/associations/with_valid_rna' } do
          description SwaggerInformation.get('mi.association.description')

          schema build_rswag_response(
            id: valid_rna_id,
            type: 'association',
            attributes: SwaggerInformation.get('mi.association.attributes')
          )

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
