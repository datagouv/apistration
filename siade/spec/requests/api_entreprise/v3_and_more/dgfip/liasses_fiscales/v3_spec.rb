require 'swagger_helper'

RSpec.describe 'DGFIP: Déclarations des liasses Fiscales', api: :entreprise, type: %i[request swagger] do
  path '/v3/dgfip/unites_legales/{siren}/liasses_fiscales/{year}' do
    get SwaggerData.get('dgfip.liasses_fiscales.declarations.title') do
      tags(*SwaggerData.get('dgfip.liasses_fiscales.declarations.tags'))

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

      too_many_requests(DGFIP::LiassesFiscales) do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée' do
          before do
            mock_valid_dgfip_liasse_fiscale(valid_siren(:liasse_fiscale), 2017)
          end

          description SwaggerData.get('dgfip.liasses_fiscales.declarations.description')

          cacheable_response(extra_description: SwaggerData.get('response.headers.cache_duration_1_hour'))

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('dgfip.liasses_fiscales.declarations.attributes'),
            meta: SwaggerData.get('dgfip.liasses_fiscales.declarations.meta')
          )

          run_test!
        end

        describe 'invalid response' do
          before do
            mock_invalid_dgfip_liasse_fiscale(404)
          end

          response '404', 'Pas de liasses fiscales pour cette unité légale' do
            build_rswag_example(NotFoundError.new('DGFIP - Adélie'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:liasse_fiscale) }

          unprocessable_content_error_request(:siren)

          common_provider_errors_request(
            'DGFIP - Adélie',
            DGFIP::LiassesFiscales,
            DGFIPPotentialNotFoundError.new
          )

          common_network_error_request('DGFIP - Adélie', DGFIP::LiassesFiscales)
        end
      end
    end
  end
end
