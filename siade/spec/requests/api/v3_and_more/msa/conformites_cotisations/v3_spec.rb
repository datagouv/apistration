require 'swagger_helper'

RSpec.describe 'MSA: Conformitescotisations', type: %i[request swagger] do
  path '/v3/msa/conformites_cotisations/{siret}' do
    get SwaggerData.get('msa.conformites_cotisations.title') do
      tags(*SwaggerData.get('msa.conformites_cotisations.tags'))

      parameter_siret
      common_action_attributes

      unauthorized_request do
        let(:siret) { valid_siret(:msa) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:msa) }
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Entreprise trouvée' do
          before do
            mock_msa_cotisations(siret, :up_to_date)
          end

          description SwaggerData.get('msa.conformites_cotisations.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('msa.conformites_cotisations.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { valid_siret(:msa) }

          unprocessable_entity_error_request(:siret)

          response '404', 'Non trouvée' do
            before do
              mock_msa_cotisations(siret, :unknown)
            end

            let(:siret) { not_found_siret(:msa) }

            schema '$ref' => '#/components/schemas/NotFound'

            run_test!
          end

          common_provider_errors_request('MSA', MSA::ConformitesCotisations)
          common_network_error_request('MSA', MSA::ConformitesCotisations)
        end
      end
    end
  end
end
