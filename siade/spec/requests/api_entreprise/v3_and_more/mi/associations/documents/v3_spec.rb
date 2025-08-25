require 'swagger_helper'

RSpec.describe 'MI: Documents Associations', api: :entreprise, type: %i[request swagger] do
  path '/v3/ministere_interieur/rna/associations/{siret_or_rna}/documents' do
    get SwaggerData.get('mi.v3/document_association.title') do
      deprecated true

      tags(*SwaggerData.get('mi.v3/document_association.tags'))

      parameter_siret_or_rna

      cacheable_request

      common_action_attributes

      unauthorized_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      forbidden_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      too_many_requests(MI::Associations::Documents) do
        let(:siret_or_rna) { valid_rna_id }
      end

      describe 'with valid token and mandatory params', :valid do
        response 200, 'Document Association found', vcr: { cassette_name: 'mi/associations/documents/with_documents' } do
          let(:siret_or_rna) { '77571979202585' }

          cacheable_response(extra_description: SwaggerData.get('response.headers.cache_duration_1_hour'))

          description SwaggerData.get('mi.v3/document_association.description')

          schema build_rswag_response_collection(
            properties: SwaggerData.get('mi.v3/document_association.items.properties'),
            meta: SwaggerData.get('mi.v3/document_association.meta')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          unprocessable_content_error_request(:siret_or_rna)

          common_provider_errors_request(
            'MI',
            MI::Associations::Documents,
            documents_errors('MI')
          )

          response '404', 'Association not found', vcr: { cassette_name: 'mi/associations/with_rna_not_found' } do
            let(:siret_or_rna) { non_existing_rna_id }

            build_rswag_example(NotFoundError.new('MI'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('MI', MI::Associations::Documents)
        end
      end
    end
  end
end
