require 'swagger_helper'

RSpec.describe 'INPI RNE: Bénéficiaires effectifs', api: :entreprise, type: %i[request swagger] do
  path '/v3/inpi/rne/unites_legales/{siren}/beneficiaires_effectifs' do
    get SwaggerData.get('inpi_rne.beneficiaires_effectifs.title') do
      tags(*SwaggerData.get('inpi_rne.beneficiaires_effectifs.tags'))

      common_action_attributes

      cacheable_request

      parameter_siren

      unauthorized_request do
        let(:siren) { valid_siren }
      end

      forbidden_request do
        let(:siren) { valid_siren }
      end

      too_many_requests(INPI::RNE::BeneficiairesEffectifs) do
        let(:siren) { valid_siren }
      end

      describe 'with valid token and mandatory params', :valid, vcr: { cassette_name: 'inpi/rne/authenticate' } do
        describe 'with valid siren' do
          before do
            stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}").and_return(
              status: 200,
              body: read_payload_file('inpi/rne/beneficiaires_effectifs/valid.json')
            )
          end

          let(:siren) { valid_siren }

          response '200', 'Bénéficiaires effectifs trouvés' do
            cacheable_response(extra_description: SwaggerData.get('inpi_rne.beneficiaires_effectifs.cache_duration'))
            description SwaggerData.get('inpi_rne.beneficiaires_effectifs.description')

            rate_limit_headers

            schema build_rswag_response_collection(
              properties: SwaggerData.get('inpi_rne.beneficiaires_effectifs.attributes'),
              meta: SwaggerData.get('inpi_rne.beneficiaires_effectifs.meta')
            )

            run_test!
          end
        end

        describe 'not found' do
          before do
            stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}").and_return(
              status: 404
            )
          end

          response '404', 'Bénéficiaires effectifs non trouvés' do
            let(:siren) { non_existent_siren }

            build_rswag_example(NotFoundError.new('INPI - RNE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          let(:siren) { valid_siren }

          unprocessable_content_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          common_provider_errors_request('INPI - RNE', INPI::RNE::BeneficiairesEffectifs)
          common_network_error_request('INPI - RNE', INPI::RNE::BeneficiairesEffectifs)
        end
      end
    end
  end
end
