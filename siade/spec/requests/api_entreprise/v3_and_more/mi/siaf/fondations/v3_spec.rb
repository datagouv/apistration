require 'swagger_helper'

RSpec.describe 'MI - SIAF : Fondations', api: :entreprise, type: %i[request swagger] do
  path '/v3/ministere_interieur/siaf/fondations/{siren_or_siret_or_rnf}' do
    get SwaggerData.get('siaf.fondations.title') do
      tags(*SwaggerData.get('siaf.fondations.tags'))

      parameter_siren_or_siret_or_rnf

      common_action_attributes

      unauthorized_request do
        let(:siren_or_siret_or_rnf) { valid_rnf_id }
      end

      forbidden_request do
        let(:siren_or_siret_or_rnf) { valid_rnf_id }
      end

      too_many_requests(MI::SIAF::Fondations) do
        let(:siren_or_siret_or_rnf) { valid_rnf_id }
      end

      describe 'with valid token and mandatory params', :valid do
        response 200, 'Fondation trouvée' do
          description SwaggerData.get('siaf.fondations.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('siaf.fondations.attributes')
          )

          rate_limit_headers

          let(:siren_or_siret_or_rnf) { valid_rnf_id }

          run_test!
        end

        describe 'server errors' do
          let(:siren_or_siret_or_rnf) { valid_rnf_id }

          unprocessable_content_error_request(:siren_or_siret_or_rnf)

          response '404', 'Fondation non trouvée' do
            let(:siren_or_siret_or_rnf) { non_existing_rnf_id }

            build_rswag_example(NotFoundError.new('SIAF'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('SIAF', MI::SIAF::Fondations)
          common_network_error_request('SIAF', MI::SIAF::Fondations)
        end
      end
    end
  end
end
