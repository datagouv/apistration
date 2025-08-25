require 'swagger_helper'

RSpec.describe 'MSA: Conformitescotisations', api: :entreprise, type: %i[request swagger] do
  path '/v3/msa/etablissements/{siret}/conformite_cotisations' do
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

      too_many_requests(MSA::ConformitesCotisations) do
        let(:siret) { valid_siret(:msa) }
      end

      describe 'with valid token and mandatory params', :valid do
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

          unprocessable_content_error_request(:siret)

          response '404', 'Non trouvée' do
            before do
              mock_msa_cotisations(siret, :unknown)
            end

            let(:siret) { not_found_siret(:msa) }

            build_rswag_example(NotFoundError.new('MSA'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('MSA', MSA::ConformitesCotisations)
          common_network_error_request('MSA', MSA::ConformitesCotisations)
        end
      end
    end
  end
end
