require 'swagger_helper'

RSpec.describe 'MI : Associations', api: :entreprise, type: %i[request swagger] do
  path '/v3/ministere_interieur/rna/associations/{siret_or_rna}' do
    get SwaggerData.get('mi.v3/association.title') do
      deprecated true

      tags(*SwaggerData.get('mi.v3/association.tags'))

      cacheable_request

      parameter_siret_or_rna

      common_action_attributes

      unauthorized_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      forbidden_request do
        let(:siret_or_rna) { valid_rna_id }
      end

      too_many_requests(MI::Associations) do
        let(:siret_or_rna) { valid_rna_id }
      end

      describe 'with valid token and mandatory params', :valid do
        response 200, 'Association found', vcr: { cassette_name: 'mi/associations/with_valid_rna' } do
          cacheable_response(extra_description: SwaggerData.get('response.headers.cache_duration_1_hour'))

          description SwaggerData.get('mi.v3/association.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('mi.v3/association.attributes')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret_or_rna) { valid_rna_id }

          unprocessable_content_error_request(:siret_or_rna)

          response '404', 'Association not found', vcr: { cassette_name: 'mi/associations/with_rna_not_found' } do
            let(:siret_or_rna) { non_existing_rna_id }

            build_rswag_example(NotFoundError.new('MI'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('MI', MI::Associations)
          common_provider_errors_request('MI', MI::Associations)
        end
      end
    end
  end
end
