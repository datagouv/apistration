require 'swagger_helper'

RSpec.describe 'DGFIP: Lienscapitalistiques', api: :entreprise, type: %i[request swagger] do
  path '/v3/dgfip/unites_legales/{siren}/liens_capitalistiques/{year}' do
    get SwaggerData.get('dgfip.liens_capitalistiques.title') do
      tags(*SwaggerData.get('dgfip.liens_capitalistiques.tags'))

      cacheable_request

      common_action_attributes

      parameter name: :siren, in: :path, type: :string
      parameter name: :year, in: :path, type: :integer

      let(:year) { 2017 }

      unauthorized_request do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      too_many_requests(DGFIP::LiensCapitalistiques) do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      too_many_requests(DGFIP::LiensCapitalistiques) do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Liens capitalistiques trouvées' do
          before do
            mock_valid_dgfip_liasse_fiscale(siren, year, 'liens_capitalistiques')
          end

          description SwaggerData.get('dgfip.liens_capitalistiques.description')

          cacheable_response(extra_description: SwaggerData.get('response.headers.cache_duration_1_hour'))

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('dgfip.liens_capitalistiques.attributes')
          )

          run_test!
        end

        describe 'not found' do
          before do
            mock_invalid_dgfip_liasse_fiscale(404)
          end

          response '404', 'Non trouvé' do
            build_rswag_example(NotFoundError.new('DGFIP - Adélie'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          unprocessable_entity_error_request(:siren)

          common_provider_errors_request('DGFIP - Adélie', DGFIP::LiensCapitalistiques)
          common_network_error_request('DGFIP - Adélie', DGFIP::LiensCapitalistiques)
        end
      end
    end
  end
end
