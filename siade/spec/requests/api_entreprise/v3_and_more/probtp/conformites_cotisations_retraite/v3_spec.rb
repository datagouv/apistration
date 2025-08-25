require 'swagger_helper'

RSpec.describe 'PROBTP: Conformites Cotisations Retraite', api: :entreprise, type: %i[request swagger] do
  path '/v3/probtp/etablissements/{siret}/conformite_cotisations_retraite' do
    get SwaggerData.get('probtp.conformites_cotisations_retraite.title') do
      tags(*SwaggerData.get('probtp.conformites_cotisations_retraite.tags'))

      common_action_attributes

      parameter name: :siret, in: :path, type: :string

      unauthorized_request do
        let(:siret) { eligible_siret(:probtp) }
      end

      forbidden_request do
        let(:siret) { eligible_siret(:probtp) }
      end

      too_many_requests(PROBTP::ConformitesCotisationsRetraite) do
        let(:siret) { eligible_siret(:probtp) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_eligible_siret' } do
          description SwaggerData.get('probtp.conformites_cotisations_retraite.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('probtp.conformites_cotisations_retraite.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { eligible_siret(:probtp) }

          unprocessable_content_error_request(:siret)

          response '404', 'Non trouvée', vcr: { cassette_name: 'probtp/conformites_cotisations_retraite/with_not_found_siret' } do
            let(:siret) { not_found_siret(:probtp) }

            build_rswag_example(NotFoundError.new('ProBTP'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('ProBTP', PROBTP::ConformitesCotisationsRetraite)
          common_network_error_request('ProBTP', PROBTP::ConformitesCotisationsRetraite)
        end
      end
    end
  end
end
