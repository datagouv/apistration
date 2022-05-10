require 'swagger_helper'

RSpec.describe 'RNM: Entreprises artisanales', type: %i[request swagger] do
  path '/v3/rnm/entreprises/{siren}' do
    get SwaggerData.get('rnm.entreprise_artisanale.title') do
      tags(*SwaggerData.get('rnm.entreprise_artisanale.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:rnm_cma) }
      end

      describe 'with valid token and mandatory params', valid: true do
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

          unprocessable_entity_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          not_found_error_request('RNM', RNM::EntreprisesArtisanales)
          common_provider_errors_request('RNM', RNM::EntreprisesArtisanales)
          common_network_error_request('RNM', RNM::EntreprisesArtisanales)
        end
      end
    end
  end
end
