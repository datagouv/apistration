require 'swagger_helper'

RSpec.describe 'MI: Documents Associations', type: %i[request swagger] do
  path '/v3/mi/associations/{siret_or_rna}/documents' do
    get SwaggerData.get('mi.document_association.title') do
      tags(*SwaggerData.get('mi.document_association.tags'))

      parameter_siret_or_rna

      common_action_attributes

      unauthorized_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      forbidden_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      describe 'with valid token and mandatory params', valid: true do
        response 200, 'Document Association found', vcr: { cassette_name: 'mi/associations/documents/with_documents' } do
          let(:siret_or_rna) { '77571979202585' }

          description SwaggerData.get('mi.document_association.description')

          schema build_rswag_response_collection(
            properties: SwaggerData.get('mi.document_association.items.properties'),
            meta: SwaggerData.get('mi.document_association.meta')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret_or_rna) { '77571979202585' }

          unprocessable_entity_error_request(:siret_or_rna) do
            let(:siret_or_rna) { 'lol' }
          end

          not_found_error_request('MI', MI::Associations::Documents)
          common_provider_errors_request('MI', MI::Associations::Documents)
          common_network_error_request('MI', MI::Associations::Documents)
        end
      end
    end
  end
end
