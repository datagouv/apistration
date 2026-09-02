require 'swagger_helper'

RSpec.describe 'MI - SIAF : Associations en open data', api: :entreprise, type: %i[request swagger] do
  path '/v3/ministere_interieur/siaf/associations/open_data/{siren_or_siret_or_rna}' do
    get SwaggerData.get('siaf.associations_open_data.title') do
      tags(*SwaggerData.get('siaf.associations_open_data.tags'))

      parameter_siren_or_siret_or_rna

      common_action_attributes

      unauthorized_request do
        let(:siren_or_siret_or_rna) { siaf_association_rna_id }
      end

      forbidden_request do
        let(:siren_or_siret_or_rna) { siaf_association_rna_id }
      end

      too_many_requests(MI::SIAF::Associations) do
        let(:siren_or_siret_or_rna) { siaf_association_rna_id }
      end

      describe 'with valid token and mandatory params', :valid do
        response 200, 'Association trouvée' do
          description SwaggerData.get('siaf.associations_open_data.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('siaf.associations_open_data.attributes'),
            meta: SwaggerData.get('siaf.associations_open_data.meta')
          )

          rate_limit_headers

          let(:siren_or_siret_or_rna) { siaf_association_rna_id }

          run_test!
        end

        describe 'server errors' do
          let(:siren_or_siret_or_rna) { siaf_association_rna_id }

          unprocessable_content_error_request(:siren_or_siret_or_rna)

          response '404', 'Association non trouvée' do
            let(:siren_or_siret_or_rna) { non_existing_rna_id }

            build_rswag_example(NotFoundError.new('SIAF'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('SIAF', MI::SIAF::Associations)
          common_network_error_request('SIAF', MI::SIAF::Associations)
        end
      end
    end
  end
end
