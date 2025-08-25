require 'swagger_helper'

RSpec.describe 'RNM: Entreprises artisanales', api: :entreprise, type: %i[request swagger] do
  path '/v3/cma_france/rnm/unites_legales/{siren}' do
    get SwaggerData.get('rnm.entreprise_artisanale.title') do
      tags(*SwaggerData.get('rnm.entreprise_artisanale.tags'))

      parameter_siren

      deprecated true

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      too_many_requests(RNM::EntreprisesArtisanales) do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise found', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
          description SwaggerData.get('rnm.entreprise_artisanale.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('rnm.entreprise_artisanale.attributes')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siren) { sirens_insee_v3[:active_GE] }

          unprocessable_content_error_request(:siren)

          response '404', 'Entreprise non trouvée', vcr: { cassette_name: 'rnm_cma/not_found_siren' } do
            let(:siren) { not_found_siren(:rnm_cma) }

            build_rswag_example(NotFoundError.new('RNM'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('RNM', RNM::EntreprisesArtisanales)
          common_network_error_request('RNM', RNM::EntreprisesArtisanales)
        end
      end
    end
  end
end
