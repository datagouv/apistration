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

      describe 'with valid token and mandatory params', valid: true do
        response 200, 'Association found', vcr: { cassette_name: 'mi/associations/with_valid_rna' } do
          description SwaggerData.get('mi.association.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('mi.association.attributes')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret_or_rna) { valid_rna_id }

          unprocessable_entity_error_request(:siret_or_rna)

          not_found_error_request('MI', MI::Associations)
          common_network_error_request('MI', MI::Associations)
          common_provider_errors_request('MI', MI::Associations)
        end
      end
    end
  end
end
